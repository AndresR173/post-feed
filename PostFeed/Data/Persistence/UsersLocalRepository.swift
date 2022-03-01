//
//  File.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct UsersLocalRepository: UsersRepository {
    private let client: CoreDataClient = ServiceLocator.shared.resolve()

    func getUserBy(id: Int) -> AnyPublisher<User, Error> {
        return client.get(entity: UserEntity.self,
                          predicate: NSPredicate(format: "id = %d", id))
            .tryMap { userE in
                guard let userE = userE else {
                    throw Failure.notFound
                }
                return User.fromEntity(userE)
            }
            .eraseToAnyPublisher()
    }

    func addUser(_ user: User) -> AnyPublisher<User, Error> {
        return client.add(entity: UserEntity.self) { entity in
            entity.id = Int32(user.id)
            entity.name = user.name
            entity.website = user.website
            entity.phone = user.phone

        }.map { entity in
            return User.fromEntity(entity)
        }
        .eraseToAnyPublisher()
    }

}
