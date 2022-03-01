//
//  PostDetailsViewModel.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import Foundation
import Combine

protocol PostDetailsViewModelProtocol {

    /// This struct is an animation wrapper, used to load Lottie animations
    var animation: Box<AppAnimation?> { get }

    /// Post element
    var post: Box<Post?> { get }
    var user: Box<User?> { get }
    var comments: Box<[Comment]?> { get }

    func updateFavoriteStatus()
}

final class PostDetailsViewModel: PostDetailsViewModelProtocol {

    private let postsManager: PostsDataManager
    private let usersManager: UsersDataManager
    private let commentsManager: CommentsDataManager
    private let postId: Int

    var animation: Box<AppAnimation?> = Box(nil)
    var post: Box<Post?> = Box(nil)
    var user: Box<User?> = Box(nil)
    var comments: Box<[Comment]?> = Box(nil)

    private var cancellables = Set<AnyCancellable>()

    init(postId: Int,
         _ postsDataManager: PostsDataManager? = nil,
         _ usersDataManager: UsersDataManager? = nil,
         _ commentsDataManager: CommentsDataManager? = nil) {
        self.postId = postId

        postsManager = postsDataManager ?? ServiceLocator.shared.resolve()
        usersManager = usersDataManager ?? ServiceLocator.shared.resolve()
        commentsManager = commentsDataManager ?? ServiceLocator.shared.resolve()

        getPostInfo()
    }
}

extension PostDetailsViewModel {
    private func getPostInfo() {
        animation.value = AppAnimation(animation: Constants.Animations.searching, message: "Loading".L)

        postsManager.getPostBy(id: postId)
            .flatMap { post in
                self.usersManager.getUserWith(id: post.userId)
                    .map { user in
                        (post: post, user: user)
                    }

            }
            .flatMap { response in
                self.commentsManager.getCommentsFromPostWith(id: self.postId)
                    .map { comments in
                        (post: response.post, user: response.user, comments: comments)
                    }
            }
            .mapError { [weak self] error -> Error in

                guard let strongSelf = self else {
                    return error
                }

                strongSelf.animation.value = AppAnimation(animation: Constants.Animations.error,
                                                          message: "Ops! something went wrong".L)
                return error
            }
            .sink(receiveCompletion: { _ in}, receiveValue: {[weak self] response in
                self?.animation.value = nil
                self?.user.value = response.user
                self?.comments.value = response.comments
                self?.post.value = response.post
            })
            .store(in: &cancellables)

    }

    func updateFavoriteStatus() {
        post.value?.isFavorite.toggle()
    }
}
