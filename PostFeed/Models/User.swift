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
