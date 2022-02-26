//
//  PostsNetworkRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct NetworkPostRepository: PostsRepository {
    let apiClient = APIClient()

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = Constants.Api.Paths.posts

        guard let url = urlComponents.url else {
            return Fail(error: Failure.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func removePost() -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

    func markPostAsFavorite(_ id: Int) -> AnyPublisher<Any, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }
}
