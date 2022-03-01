//
//  CommentsDataManager.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import Foundation
import Combine

struct CommentsDataManager {

    private let localRepository: CommentsRepository
    private let networkRepository: CommentsRepository

    private var cancellables = Set<AnyCancellable>()

    init(_ local: CommentsRepository, _ network: CommentsRepository) {
        localRepository = local
        networkRepository = network
    }

    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error> {
        localRepository.getCommentsFromPostWith(id: id)
            .tryCatch { _ in
                self.networkRepository.getCommentsFromPostWith(id: id)
                    .map {
                        self.saveCommentsInCache(comments: $0)
                        return $0
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    private func saveCommentsInCache(comments: [Comment]) {
        let operationPublishers = comments.map { comment in
            return localRepository.addComment(comment).eraseToAnyPublisher()
        }

       _ = operationPublishers
            .publisher
            .collect()
    }
}
