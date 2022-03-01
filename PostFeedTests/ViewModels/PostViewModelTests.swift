//
//  PostViewModelTests.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import XCTest
@testable import PostFeed

class PostViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingAnimationShown() {
        let sut = PostsViewModel(PostsDataManager(MockSuccessulPostsRepository(),
                                                  MockSuccessulPostsRepository()))
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to update the animation status")

        sut.animation.bind { animation in
            if animation != nil {
                XCTAssertEqual(animation!.animation, Constants.Animations.loading)
                expectation.fulfill()
            }
        }

        sut.getPosts()

        wait(for: [expectation], timeout: 2)
    }

    func testDeletePostShouldUpdateList() {
        var posts: [Post] = []
        let sut = PostsViewModel(PostsDataManager(MockSuccessulPostsRepository(),
                                                  MockSuccessulPostsRepository()))
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to update posts list")
        var isFirstCall: Bool = true

        sut.getPosts()

        sut.posts.bind { response in
            if let response = response {
                if isFirstCall {
                    posts = response
                    XCTAssert(!posts.isEmpty)
                } else {
                    expectation.fulfill()
                    XCTAssertEqual(posts.count - 1, response.count)
                }
            }
        }

        sleep(2)

        isFirstCall = false

        sut.deletePostAt(index: 0)

        wait(for: [expectation], timeout: 2)
    }

    func testUpdateFavoriteStatusShouldUpdatePostList() {
        var posts: [Post] = []
        let sut = PostsViewModel(PostsDataManager(MockSuccessulPostsRepository(),
                                                  MockSuccessulPostsRepository()))
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to update posts list")
        var isFirstCall: Bool = true

        sut.getPosts()

        sut.posts.bind { response in
            if let response = response {
                if isFirstCall {
                    posts = response
                    XCTAssert(!(posts.first?.isFavorite ?? false))
                } else {
                    expectation.fulfill()
                    XCTAssertNotEqual(posts.first?.isFavorite, response.first?.isFavorite)
                    XCTAssertTrue(response.first?.isFavorite ?? false)
                }
            }
        }

        isFirstCall = false

        sut.updateFavoriteStatus(atIndex: 0)

        wait(for: [expectation], timeout: 2)
    }

    func testDeleteListShouldShowEmptyState() {
        var posts: [Post] = []
        let sut = PostsViewModel(PostsDataManager(MockSuccessulPostsRepository(),
                                                  MockSuccessulPostsRepository()))
        let expectation = XCTestExpectation(description: "Wait for the ViewModel to update posts list")
        var isFirstCall: Bool = true

        sut.getPosts()

        sut.posts.bind { response in
                if isFirstCall {

                    XCTAssertNotNil(response)
                    posts = response!
                    XCTAssert(!posts.isEmpty)
                } else {

                    expectation.fulfill()
                    XCTAssertNil(response)
                }

        }

        sut.animation.bind { animation in
            if !isFirstCall {
                XCTAssertEqual(animation?.animation, Constants.Animations.empty)
            }
        }

        isFirstCall = false

        sut.deletePosts()

        wait(for: [expectation], timeout: 2)
    }

}
