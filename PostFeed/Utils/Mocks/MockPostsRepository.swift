//
//  ErroredLocalRepository.swift
//  PostFeedTests
//
//  Created by Andres Rojas on 1/03/22.
//

import Foundation
import Combine

final class MockErroredPostsRepository: PostsRepository {
    func getAllPosts() -> AnyPublisher<[Post], Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

    func getPostBy(id: Int) -> AnyPublisher<Post, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

    func removePost(id: Int) -> AnyPublisher<Void, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

    func updateFavoriteStatus(_ status: Bool, withId id: Int) -> AnyPublisher<Post, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

    func addPost(post: Post) -> AnyPublisher<Post, Error> {
        return Fail(error: Failure.serverError).eraseToAnyPublisher()
    }

}

final class MockSuccessulPostsRepository: PostsRepository {

    let posts: [Post]

    let fakePost = Post(id: 999, userId: 999, title: "title", body: "body")

    init() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "posts", withExtension: "json") else {

            posts = [
                fakePost
            ]
            return
        }

        guard let data = try? Data(contentsOf: url) else {

            posts = [
                fakePost
            ]
            return
        }

        do {
            posts = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            posts = [
                fakePost
            ]
        }
    }

    func getAllPosts() -> AnyPublisher<[Post], Error> {
        return Result.Publisher(posts).eraseToAnyPublisher()
    }

    func getPostBy(id: Int) -> AnyPublisher<Post, Error> {
        return Result.Publisher(posts.first!).eraseToAnyPublisher()
    }

    func removePost(id: Int) -> AnyPublisher<Void, Error> {
        return Result.Publisher(()).eraseToAnyPublisher()
    }

    func updateFavoriteStatus(_ status: Bool, withId id: Int) -> AnyPublisher<Post, Error> {
        guard var post = posts.first(where: {$0.id == id}) else {
            return Fail(error: Failure.serverError).eraseToAnyPublisher()
        }
        post.isFavorite.toggle()

        return Result.Publisher(post).eraseToAnyPublisher()
    }

    func addPost(post: Post) -> AnyPublisher<Post, Error> {
        return Result.Publisher(post).eraseToAnyPublisher()
    }

}
