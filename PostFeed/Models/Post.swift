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
