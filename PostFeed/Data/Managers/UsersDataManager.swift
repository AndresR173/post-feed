//
//  UsersDataManager.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation

struct UsersDataManager {

    let networkRepository: UsersRepository
    let localRepository: UsersRepository

    init(_ localRepo: UsersRepository, networkRepo: UsersRepository) {
        self.networkRepository = networkRepo
        self.localRepository = localRepo
    }
}
