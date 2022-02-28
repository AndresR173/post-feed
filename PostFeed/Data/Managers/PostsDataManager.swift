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

    func getAllPosts(forced: Bool) -> AnyPublisher<[Post], Error> {
        if forced {
            return getPostFromNetworkAndCache()
        }
        return localRepository.getAllPosts()
            .catch {  _ in
                return self.getPostFromNetworkAndCache()
            }
            .eraseToAnyPublisher()
    }

    private func getPostFromNetworkAndCache() -> AnyPublisher<[Post], Error> {
        return self.networkRepository.getAllPosts()
            .compactMap { posts in
                self.savePostsInCache(posts: posts)

                return posts
            }.eraseToAnyPublisher()
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
        return localRepository.updateFavoriteStatus(post.isFavorite, withId: post.id)
            .map { post in
                _ = self.networkRepository.updateFavoriteStatus(post.isFavorite,
                                                                withId: post.id)

                return post
            }
            .eraseToAnyPublisher()
    }

    func deletePostWith(id: Int) -> AnyPublisher<Void, Error> {
        self.localRepository.removePost(id: id)
            .map {
                _ = self.networkRepository.removePost(id: id)
                return ()
            }
            .eraseToAnyPublisher()
    }

    func deletePosts(_ posts: [Post]) -> AnyPublisher<Void, Error> {
        Fail(error: Failure.notFound).eraseToAnyPublisher()
    }
}
