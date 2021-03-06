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
    var isFavorite: Bool = false

    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case body
    }
}

extension Post {
    static func fromEntity(_ entity: PostEntity) -> Post {
        return Post(id: Int(entity.id),
                    userId: Int(entity.userId),
                    title: entity.title ?? "",
                    body: entity.body ?? "",
                    isFavorite: entity.isFavorite
        )
    }
}
