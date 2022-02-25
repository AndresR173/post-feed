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
        
        container.register(PostViewModelProtocol.self) { _ in PostViewModel()}
    }
    
    func resolve<T>() -> T {
        
        return container.resolve(T.self)!
    }
}
