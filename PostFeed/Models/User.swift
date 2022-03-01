//
//  User.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation

struct User: Codable {
    let name: String
    let id: Int
    let email: String
    let phone: String
    let website: String
}

extension User {
    static func fromEntity(_ entity: UserEntity) -> User {
        return User(name: entity.name ?? "",
                    id: Int(entity.id),
                    email: entity.email ?? "",
                    phone: entity.phone ?? "",
                    website: entity.website ?? ""
        )
    }
}
