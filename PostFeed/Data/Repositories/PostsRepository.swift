//
//  PostsRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation
import Combine

protocol PostsRepository {
    func getAllPosts() -> AnyPublisher<[Post], Error>
    func removePost() -> AnyPublisher<Any, Error>
    func markPostAsFavorite(_ id: Int) -> AnyPublisher<Any, Error>
    func addPost(post: Post) -> AnyPublisher<Post, Error>
}
