//
//  LocalPostsRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine
import CoreData

struct PostsLocalRepository: PostsRepository {
    private let client: CoreDataClient = ServiceLocator.shared.resolve()

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        client.getAll(
            entity: PostEntity.self,
            sortDescriptor: [NSSortDescriptor(keyPath: \PostEntity.isFavorite, ascending: false)])

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

    func removePost(id: Int) -> AnyPublisher<Void, Error> {
        // return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
        let predicate = NSPredicate(format: "id == %d", id)

        return client.delete(entity: PostEntity.self, predicate: predicate)
        .eraseToAnyPublisher()
    }

    func updateFavoriteStatus(_ status: Bool, withId id: Int) -> AnyPublisher<Post, Error> {
        let predicate = NSPredicate(format: "id == %d", id)

        return client.update(entity: PostEntity.self, predicate: predicate) { entity in
            entity.isFavorite = status
        }.map { entity in
            return Post.fromEntity(entity)
        }
        .eraseToAnyPublisher()
    }

    func addPost(post: Post) -> AnyPublisher<Post, Error> {
       return client.add(entity: PostEntity.self) { entity in
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
