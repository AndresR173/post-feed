//
//  CommentsLocalRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import Foundation
import Combine

struct CommentsLocalRepository: CommentsRepository {
    private let client: CoreDataClient = ServiceLocator.shared.resolve()

    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error> {
        client.getAll(
            entity: CommentEntity.self,
            predicate: NSPredicate(format: "postId = %d", id)
        )

            .tryMap { entities in
                if entities.isEmpty {
                    throw Failure.emptyReponse
                }
                var comments = [Comment]()
                entities.forEach { entity in
                    comments.append(Comment.fromEntity(entity))
                }
                return comments
            }
            .eraseToAnyPublisher()
    }

    func addComment(_ comment: Comment) -> AnyPublisher<Comment, Error> {
        return client.add(entity: CommentEntity.self) { entity in
            entity.id = Int32(comment.id)
            entity.postId = Int32(comment.postId)
            entity.body = comment.body
            entity.email = comment.email
            entity.name = comment.name
        }.map { entity in
            return Comment.fromEntity(entity)
        }
        .eraseToAnyPublisher()
    }
}
