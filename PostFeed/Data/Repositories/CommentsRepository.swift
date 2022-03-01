//
//  CommentsRepository.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import Foundation
import Combine

protocol CommentsRepository {
    func getCommentsFromPostWith(id: Int) -> AnyPublisher<[Comment], Error>
    func addComment(_ comment: Comment) -> AnyPublisher<Comment, Error>
}
