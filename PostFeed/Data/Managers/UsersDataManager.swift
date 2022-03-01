//
//  UsersDataManager.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct UsersDataManager {

    private let networkRepository: UsersRepository
    private let localRepository: UsersRepository

    init(_ local: UsersRepository, _ network: UsersRepository) {
        self.networkRepository = network
        self.localRepository = local
    }

    func getUserFromPostWith(id: Int) -> AnyPublisher<User, Error> {
        localRepository.getUserBy(id: id)
            .tryCatch { _ in
                self.networkRepository.getUserBy(id: id)
                    .map {
                        self.saveUserInCache(user: $0)
                        return $0
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    private func saveUserInCache(user: User ) {
        _ = localRepository.addUser(user)
            .eraseToAnyPublisher()
            .collect()

    }
}
