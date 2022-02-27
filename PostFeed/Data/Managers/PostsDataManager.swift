//
//  PostsDataManager.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import Foundation
import Combine

final class PostsDataManager {
    private let localRepository: PostsRepository
    private let networkRepository: PostsRepository

    private var cancellables = Set<AnyCancellable>()

    init(_ local: PostsRepository, _ network: PostsRepository) {
        localRepository = local
        networkRepository = network
    }

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        localRepository.getAllPosts()
            .catch {  _ in
                return self.networkRepository.getAllPosts()
                    .compactMap { posts in
                        self.savePostsInCache(posts: posts)

                        return posts
                    }
            }
            .eraseToAnyPublisher()
    }

    private func savePostsInCache(posts: [Post]) {
        let operationPublishers = posts.map { post in
            return localRepository.addPost(post: post).eraseToAnyPublisher()
        }

       _ = operationPublishers
            .publisher
            .collect()
    }

    func updateFavoriteStatus(_ post: Post) -> AnyPublisher<Post, Error> {
        return localRepository.updateFavoriteStatus(post.isFavorite, withId:
                                                        post.id)
            .map { post in
                _ = self.networkRepository.updateFavoriteStatus(post.isFavorite,
                                                                withId: post.id)

                return post
            }
            .eraseToAnyPublisher()
    }
}
