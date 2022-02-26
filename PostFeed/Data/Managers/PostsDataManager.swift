//
//  PostsDataManager.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

struct PostsDataManager {
    private let localRepository: PostsRepository
    private let networkRepository: PostsRepository

    init(_ local: PostsRepository, _ network: PostsRepository) {
        localRepository = local
        networkRepository = network
    }

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        return networkRepository.getAllPosts()
    }
}
