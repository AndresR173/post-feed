//
//  UsersRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import Foundation
import Combine

protocol UsersRepository {
    func getUserBy(id: Int) -> AnyPublisher<User, Error>
    func addUser(_ user: User) -> AnyPublisher<User, Error>
}
