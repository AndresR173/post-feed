//
//  Comment.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}

extension Comment {
    static func fromEntity(_ entity: CommentEntity) -> Comment {
        return Comment(id: Int(entity.id),
                       postId: Int(entity.postId),
                       name: entity.name ?? "",
                       email: entity.email ?? "",
                       body: entity.body ?? "")
    }
}
