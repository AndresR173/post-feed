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
    @objc let refreshControl = UIRefreshControl()

    // MARK: - Life cycle

    init(_ viewModel: PostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostsViewController.self), bundle: Bundle.main)
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
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)

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

            strongSelf.refreshControl.endRefreshing()

            if posts != nil {
                strongSelf.tableView.fadeIn()
                strongSelf.tableView.reloadData()
            } else {
                strongSelf.tableView.fadeOut()
            }

        }

    }

    @objc func refreshList() {
        if refreshControl.isRefreshing {
            viewModel.getPosts(forced: true)
        }
    }
}

// MARK: - Tableview data source and delegate

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
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
                                                      handler: {(_, _, completionHandler) in

            completionHandler(true)
        })

        return UISwipeActionsConfiguration(actions: [markAsFavoriteAction])
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let markAsFavoriteAction = UIContextualAction(style: .destructive,
                                                      title: "Delete".L,
                                                      handler: {(_, _, completionHandler) in

            completionHandler(true)
        })

        return UISwipeActionsConfiguration(actions: [markAsFavoriteAction])
    }

}
