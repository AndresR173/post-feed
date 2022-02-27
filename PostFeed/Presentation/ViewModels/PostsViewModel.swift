//
//  PostViewModel.swift
//  PostFeed
//
//  Created by Andres Rojas on 25/02/22.
//

import Foundation
import Combine

protocol PostViewModelProtocol {
    func getPosts(forced: Bool)
    func updateFavoriteStatus(atIndex index: Int)

    /// This struct is an animation wrapper, used to load Lottie animations
    var animation: Box<AppAnimation?> { get }

    /// List of posts
    var posts: Box<[Post]?> { get }
}

final class PostsViewModel: PostViewModelProtocol {

    var animation: Box<AppAnimation?> = Box(nil)
    var posts: Box<[Post]?> = Box(nil)

    private let dataManager: PostsDataManager

    private var cancellables = Set<AnyCancellable>()

    init(_ manager: PostsDataManager) {
        dataManager = manager

        getPosts()
    }
}

extension PostsViewModel {

    func getPosts(forced: Bool = false) {
        animation.value = AppAnimation(animation: Constants.Animations.searching, message: "Loading".L)
        posts.value = nil
        dataManager.getAllPosts()
            .mapError { [weak self] error -> Error in

                guard let strongSelf = self else {
                    return error
                }

                strongSelf.animation.value = AppAnimation(animation: Constants.Animations.error,
                                                          message: "Ops! something went wrong".L)
                return error
            }
            .sink(receiveCompletion: { _ in}, receiveValue: {[weak self] posts in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.animation.value = nil
                if posts.isEmpty {

                    strongSelf.animation.value = AppAnimation(animation: Constants.Animations.empty,
                                                              // swiftlint:disable:next line_length
                                                              message: "We could not find any results. Please try again".L)
                } else {

                    strongSelf.posts.value = posts
                }
            })
            .store(in: &cancellables)
    }

    func updateFavoriteStatus(atIndex index: Int) {

        var newPost = posts.value![index]
        newPost.isFavorite.toggle()
        dataManager.updateFavoriteStatus(newPost)
            .sink(receiveCompletion: { _ in}, receiveValue: {[weak self] rPost in
                guard let strongSelf = self else {
                    return
                }

                if let index = strongSelf.posts.value?.firstIndex(where: { $0.id == rPost.id}) {
                    strongSelf.posts.value?[index] = rPost
                    strongSelf.posts.value?.sort(by: { post1, _ in post1.isFavorite})
                }

            })
            .store(in: &cancellables)
    }
}
