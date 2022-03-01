//
//  PostsViewController.swift
//  PostFeed
//
//  Created by Andres Rojas on 24/02/22.
//

import UIKit
import Lottie

class PostsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    let viewModel: PostViewModelProtocol
    private lazy var animationView = AnimationView()
    let postCellIdentifier = String(describing: PostTableViewCell.self)
    lazy var refreshButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down.fill"),
                               style: .plain,
                               target: self,
                               action: #selector(downloadList))
    }()
    lazy var deleteListItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "trash"),
                               style: .plain,
                               target: self,
                               action: #selector(deleteList))
    }()

    // MARK: - Life cycle

    init(_ viewModel: PostViewModelProtocol? = nil) {
        self.viewModel = viewModel ?? ServiceLocator.shared.resolve()
        super.init(nibName: String(describing: PostsViewController.self),
                   bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

// MARK: - Helper Methods

private extension PostsViewController {

    func setupUI() {

        title = "Post feed".L

        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: postCellIdentifier, bundle: .main),
                           forCellReuseIdentifier: postCellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        setupBindings()
    }

    func setupBindings() {

        viewModel.animation.bind { [weak self] animation in
            guard let strongSelf = self else {
                return
            }

            if let animation = animation {
                strongSelf.animationView.animation = Animation.named(animation.animation)
                strongSelf.animationView.loopMode = .loop
                strongSelf.animationView.play()
                strongSelf.animationContainer.fadeIn()

                strongSelf.messageLabel.text = animation.message
                strongSelf.messageLabel.fadeIn()
            } else {
                strongSelf.animationView.stop()
                strongSelf.animationContainer.fadeOut()
                strongSelf.messageLabel.fadeOut()
            }
        }

        viewModel.posts.bind {[weak self] posts in
            guard let strongSelf = self else {
                return
            }

            if posts != nil {
                strongSelf.tableView.fadeIn()
                strongSelf.tableView.reloadData()
                strongSelf.navigationItem.rightBarButtonItem = strongSelf.deleteListItem
            } else {
                strongSelf.tableView.fadeOut()
                strongSelf.navigationItem.rightBarButtonItem = strongSelf.refreshButtonItem
            }

        }

    }

    @objc func downloadList() {
        viewModel.getPosts(forced: true)
    }

    @objc func deleteList() {
        showDeleteDialog(title: "Delete".L,
                               message: "Are you sure you want to delete all posts?".L
        ) { [weak self] in
            self?.viewModel.deletePosts()
        }
    }
}

// MARK: - Tableview data source and delegate

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.posts.value?.count ?? 0 > 0 ? 1: 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier,
                                                 for: indexPath) as! PostTableViewCell
        cell.post = viewModel.posts.value?[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = viewModel.posts.value?[indexPath.row]
        let favoriteActionTitle = post?.isFavorite ?? false ?  "Remove from favorites" : "Favorite".L
        let markAsFavoriteAction = UIContextualAction(style: .normal,
                                                      title: favoriteActionTitle,
                                                      handler: {[weak self] (_, _, completionHandler) in

            self?.viewModel.updateFavoriteStatus(atIndex: indexPath.row)
            completionHandler(true)
        })

        return UISwipeActionsConfiguration(actions: [markAsFavoriteAction])
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete".L,
                                              handler: {[weak self] (_, _, completionHandler) in

            self?.showDeleteDialog(title: "Delete".L,
                                   message: "Are you sure you want to delete this post?".L
            ) {
                self?.viewModel.deletePostAt(index: indexPath.row)
            }

            completionHandler(true)
        })

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = viewModel.posts.value?[indexPath.row] else {
            return
        }

        navigationController?.pushViewController(PostDetailViewController(PostDetailsViewModel(postId: post.id)),
                                                 animated: true)
    }

}
