//
//  PostsDataManagerTest.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import XCTest
@testable import PostFeed

class PostsDataManagerTest: XCTestCase {

    var erroredLocalRepository: PostsRepository!
    var erroredNetworkRepository: PostsRepository!
    var successfulLocalRepository: PostsRepository!
    var successfulNetworkRepository: PostsRepository!

    override func setUpWithError() throws {

        erroredLocalRepository = MockErroredPostsRepository()
        erroredNetworkRepository = MockErroredPostsRepository()
        successfulLocalRepository = MockSuccessulPostsRepository()
        successfulNetworkRepository = MockSuccessulPostsRepository()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldCallNetworkApiWhenLocalFails() {
        let sut = PostsDataManager(erroredLocalRepository, successfulNetworkRepository)
        let expectation = XCTestExpectation(description: "Wait for the Network APi return post list")

        _ = sut.getAllPosts(forced: false)

            .sink(receiveCompletion: {_ in }, receiveValue: { posts in
                expectation.fulfill()
                XCTAssertNotNil(posts)
                XCTAssert(!posts.isEmpty)
            })
        wait(for: [expectation], timeout: 2)
    }

    func testShouldReturnErrorIfRepositoriesFail() {
        let sut = PostsDataManager(erroredLocalRepository, erroredLocalRepository)
        let expectation = XCTestExpectation(description: "Wait for the data manager to return a response")

        _ = sut.getAllPosts(forced: false)

            .sink(receiveCompletion: { completion in
                expectation.fulfill()
                var failed: Bool = false
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    failed = true
                case .finished:
                    failed = false
                }
                XCTAssertTrue(failed)
            }, receiveValue: { _ in

            })
        wait(for: [expectation], timeout: 2)
    }

}
