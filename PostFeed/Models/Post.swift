//
//  Post.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var isFavorite: Bool? = false
}

extension Post {
    static func fromEntity(_ entity: PostEntity) -> Post {
        return Post(id: Int(entity.id),
                    userId: Int(entity.userId),
                    title: entity.title ?? "",
                    body: entity.body ?? "")
    }
}
