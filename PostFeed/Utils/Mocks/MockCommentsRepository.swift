//
//  MockCommentsRepository.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import Foundation
import Combine

final class MockSuccessfulCommentsRepository: CommentsRepository {
    let comments: [Comment] = [
        Comment(id: 999, postId: 999, name: "test", email: "test@test.com", body: "this is a test"),
        Comment(id: 999, postId: 999, name: "test 2", email: "test@test.com", body: "this is a test")
    ]
    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error> {
        return Result.Publisher(comments).eraseToAnyPublisher()
    }
    func addComment(_ comment: Comment) -> AnyPublisher<Comment, Error> {
        return Result.Publisher(comments.first!).eraseToAnyPublisher()
    }
}

final class MockErroredCommentsRepository: CommentsRepository {

    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }
    func addComment(_ comment: Comment) -> AnyPublisher<Comment, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }
}
