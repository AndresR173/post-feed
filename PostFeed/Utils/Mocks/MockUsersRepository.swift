//
//  MockUsersRepository.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import Foundation
import Combine

final class MockUserSuccessfulRepository: UsersRepository {
    let user = User(name: "Test user", id: 999, email: "test@email.com", phone: "1230000", website: "test.com")

    func getUserBy(id: Int) -> AnyPublisher<User, Error> {
        return Result.Publisher(user).eraseToAnyPublisher()
    }

    func addUser(_ user: User) -> AnyPublisher<User, Error> {
        return Result.Publisher(user).eraseToAnyPublisher()
    }
}

final class MockUserErroredfulRepository: UsersRepository {
    let user = User(name: "Test user", id: 999, email: "test@email.com", phone: "1230000", website: "test.com")

    func getUserBy(id: Int) -> AnyPublisher<User, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

    func addUser(_ user: User) -> AnyPublisher<User, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }
}
