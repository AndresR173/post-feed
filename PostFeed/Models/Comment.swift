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
