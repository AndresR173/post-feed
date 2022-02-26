//
//  ServiceLocator.swift
//  PostFeed
//
//  Created by Andres Rojas on 25/02/22.
//

import Foundation
import Swinject

final class ServiceLocator {

    static let shared = ServiceLocator()

    let container = Container()

    func initialize() {

        // Data Managers
        container.register(CoreDataClient.self) { _ in CoreDataClient()}
        container.register(PostsDataManager.self) { _ in PostsDataManager(LocalPostsRepository(),
                                                                          NetworkPostRepository())
        }

        // ViewModels
        container.register(PostViewModelProtocol.self) { _ in PostsViewModel(self.resolve())}

    }

    func resolve<T>() -> T {

        return container.resolve(T.self)!
    }
}
