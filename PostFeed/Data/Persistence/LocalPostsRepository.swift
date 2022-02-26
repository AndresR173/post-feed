//
//  LocalPostsRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct LocalPostsRepository: PostsRepository {
    func getAllPosts() -> AnyPublisher<[Post], Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

    func removePost() -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

    func markPostAsFavorite(_ id: Int) -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

}
