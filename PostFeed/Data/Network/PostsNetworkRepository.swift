//
//  PostsNetworkRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct PostNetworkRepository: PostsRepository {

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

    func removePost(id: Int) -> AnyPublisher<Void, Error> {
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = "\(Constants.Api.Paths.posts)/\(id)"

        guard let url = urlComponents.url else {
            return Fail(error: Failure.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.delete.rawValue

        return apiClient.run(request)
            .eraseToAnyPublisher()

    }

    func updateFavoriteStatus(_ status: Bool, withId id: Int) -> AnyPublisher<Post, Error> {
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = "\(Constants.Api.Paths.posts)/\(id)"

        guard let url = urlComponents.url else {
            return Fail(error: Failure.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.patch.rawValue
        let body: [String: Any] = [
            "isFavorite": status
        ]
        do {
           request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

            return apiClient.run(request)
                .map(\.value)
                .eraseToAnyPublisher()
         } catch {
             return Fail(error: Failure.badContent).eraseToAnyPublisher()
         }
    }

    func addPost(post: Post) -> AnyPublisher<Post, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }
}
