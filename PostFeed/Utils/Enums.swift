//
//  Enums.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation

enum HttpMethod: String {
    case `get` = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

enum Failure: Error {

    case serverError
    case badContent
    case badRequest
    case cacheError
    case emptyReponse
    case notFound
}
