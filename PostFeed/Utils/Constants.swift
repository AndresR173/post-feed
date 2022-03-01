//
//  Constants.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation

struct Constants {

    struct Api {

        static let host = "jsonplaceholder.typicode.com"
        static let scheme = "https"
        static let siteId = "MCO"

        static func getBaseURLComponents() -> URLComponents {

            var components = URLComponents()
            components.scheme = Constants.Api.scheme
            components.host = Constants.Api.host

            return components
        }

        // swiftlint:disable:next nesting
        struct Paths {

            static let posts = "/posts"
            static let users = "/users"
            static let comments = "/comments?postId=$1"
        }

    }

    struct Animations {

        static let error = "error"
        static let empty = "empty"
        static let loading = "searching"
    }
}
