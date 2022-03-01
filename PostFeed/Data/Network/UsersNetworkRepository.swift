//
//  NetworkUsersRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct UsersNetworkRepository: UsersRepository {

    let apiClient = APIClient()

    func getUserBy(id: Int) -> AnyPublisher<User, Error> {
        var urlComponents = Constants.Api.getBaseURLComponents()
        urlComponents.path = "\(Constants.Api.Paths.users)/\(id)"

        guard let url = urlComponents.url else {
            return Fail(error: Failure.badRequest).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func addUser(_ user: User) -> AnyPublisher<User, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

}
