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
        container.register(PostsDataManager.self) { _ in PostsDataManager(PostsLocalRepository(),
                                                                          PostNetworkRepository()) }

        container.register(UsersDataManager.self) { _ in UsersDataManager(UsersLocalRepository(),
                                                                          UsersNetworkRepository()) }

        container.register(CommentsDataManager.self) { _ in CommentsDataManager(CommentsLocalRepository(),
                                                                          CommentsNetworkRepository()) }

        // ViewModels
        container.register(PostViewModelProtocol.self) { _ in PostsViewModel()}

    }

    func resolve<T>() -> T {

        return container.resolve(T.self)!
    }
}
