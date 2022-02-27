//
//  LocalPostsRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine
import CoreData

struct LocalPostsRepository: PostsRepository {

    private let client: CoreDataClient = ServiceLocator.shared.resolve()

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        client.getAll(
            entity: PostEntity.self,
            sortDescriptor: [NSSortDescriptor(keyPath: \PostEntity.isFavorite, ascending: true)])

            .tryMap { entities in
                if entities.isEmpty {
                    throw Failure.emptyReponse
                }
                var posts = [Post]()
                entities.forEach { entity in
                    posts.append(Post.fromEntity(entity))
                }
                return posts
            }
            .eraseToAnyPublisher()
    }

    func removePost() -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

    func markPostAsFavorite(_ id: Int) -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

    func addPost(post: Post) -> AnyPublisher<Post, Error> {
        client.add(entity: PostEntity.self) { entity in
            entity.id = Int32(post.id)
            entity.userId = Int32(post.userId)
            entity.title = post.title
            entity.body = post.body
        }.map { entity in
            return Post.fromEntity(entity)
        }
        .eraseToAnyPublisher()
    }

}
