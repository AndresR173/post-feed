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
    func getPostBy(id: Int) -> AnyPublisher<Post, Error>
    func removePost(id: Int) -> AnyPublisher<Void, Error>
    func updateFavoriteStatus(_ status: Bool, withId id: Int) -> AnyPublisher<Post, Error>
    func addPost(post: Post) -> AnyPublisher<Post, Error>
}
