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
        Future<[Post], Error> {[weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.localRepository.getAllPosts()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { posts in
                    if posts.isEmpty {

                        strongSelf.networkRepository.getAllPosts()
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {

                                    promise(.failure(error))
                                }
                            }, receiveValue: { nPosts in

                                strongSelf.savePostsInCache(posts: nPosts)

                                promise(.success(nPosts))

                            }).store(in: &strongSelf.cancellables)
                    } else {

                        promise(.success(posts))

                    }
                })

                .store(in: &strongSelf.cancellables)

        }
        .eraseToAnyPublisher()
    }

    private func savePostsInCache(posts: [Post]) {
        let operationPublishers = posts.map { post in
            return localRepository.addPost(post: post).eraseToAnyPublisher()
        }

        operationPublishers
            .publisher
            .collect()
            .sink { _ in
                print("finished")
            }
            .store(in: &cancellables)
    }
}
