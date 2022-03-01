//
//  PostTests.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import XCTest
@testable import PostFeed

class PostTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserModel() throws {

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "post", withExtension: "json") else {
            XCTFail("Could not find post.json")
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Could not get data from URL")
            return
        }

        let item = try? JSONDecoder().decode(Post.self, from: data)
        XCTAssertNotNil(item)
    }

}
