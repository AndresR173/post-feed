//
//  CommentsNetworkRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import Foundation
import Combine

struct CommentsNetworkRepository: CommentsRepository {
    let apiClient = APIClient()

    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error> {
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = "\(Constants.Api.Paths.posts)/\(id)/comments"

        guard let url = urlComponents.url else {
            return Fail(error: Failure.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func addComment(_ comment: Comment) -> AnyPublisher<Comment, Error> {
        return  Fail(error: Failure.badRequest).eraseToAnyPublisher()
    }

}
