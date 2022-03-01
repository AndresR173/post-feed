//
//  PostDetailViewController.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import UIKit
import Lottie

protocol PostDetailViewControllerDelegate: AnyObject {
    func updateFavoriteStatus(_ postId: Int)
    func deletePost(_ postId: Int)
}

class PostDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let viewModel: PostDetailsViewModelProtocol
    private lazy var animationView = AnimationView()

    private let descriptionCellIdentifier = String(describing: PostDescriptionTableViewCell.self)
    private let userCellIdentifier = String(describing: PostUserTableViewCell.self)
    private let commentCellIdentifier = String(describing: PostCommentTableViewCell.self)

    lazy var deleteItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "trash"),
                               style: .plain,
                               target: self,
                               action: #selector(deletePost))
    }()

    lazy var favoriteItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "star"),
                               style: .plain,
                               target: self,
                               action: #selector(updateFavoriteStatus))
    }()

    lazy var favoritedItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                               style: .plain,
                               target: self,
                               action: #selector(updateFavoriteStatus))
    }()

    weak var delegate: PostDetailViewControllerDelegate?

    // MARK: - Life cycle

    init(_ viewModel: PostDetailsViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: PostDetailViewController.self),
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

        navigationItem.largeTitleDisplayMode = .never
    }

}

// MARK: - Helper methods
private extension PostDetailViewController {

    func setupUI() {
        title = "Post".L
        navigationController?.navigationBar.topItem?.backBarButtonItem  = UIBarButtonItem(title: "Back".L,
                                                                                          style: .plain,
                                                                                          target: nil,
                                                                                          action: nil)
        navigationItem.rightBarButtonItems = [deleteItem, favoriteItem ]
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostDescriptionTableViewCell.self, forCellReuseIdentifier: descriptionCellIdentifier )
        tableView.register(PostUserTableViewCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: commentCellIdentifier)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "postDetails.tableView"

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

        viewModel.post.bind {[weak self] post in
            guard let strongSelf = self else {
                return
            }

            if post != nil {
                strongSelf.tableView.fadeIn()
                strongSelf.tableView.reloadData()
                if post!.isFavorite {
                    strongSelf.navigationItem.rightBarButtonItems?.remove(at: 1)
                    strongSelf.navigationItem.rightBarButtonItems?.append(strongSelf.favoritedItem)
                } else {
                    strongSelf.navigationItem.rightBarButtonItems?.remove(at: 1)
                    strongSelf.navigationItem.rightBarButtonItems?.append(strongSelf.favoriteItem)
                }
            } else {
                strongSelf.tableView.fadeOut()
            }

        }

    }

    @objc func updateFavoriteStatus() {
        guard let id = viewModel.post.value?.id else {
            return
        }
        viewModel.updateFavoriteStatus()
        delegate?.updateFavoriteStatus(id)
    }

    @objc func deletePost() {
        guard let id = viewModel.post.value?.id else {
            return
        }

        showDeleteDialog(title: "Delete".L,
                               message: "Are you sure you want to delete this post?".L
        ) {[weak self] in

            self?.delegate?.deletePost(id)
            self?.navigationController?.popViewController(animated: true)
        }

    }
}

// MARK: - TableView data source & delegate

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
           return viewModel.post.value != nil ? 1: 0
        case 1:
            return viewModel.user.value != nil ? 1 : 0
        default:
            return viewModel.comments.value?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier,
                                                     for: indexPath) as! PostDescriptionTableViewCell
            cell.post = viewModel.post.value

            return cell
        case 1:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier,
                                                     for: indexPath) as! PostUserTableViewCell
            cell.user = viewModel.user.value

            return cell
        default:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier,
                                                     for: indexPath) as! PostCommentTableViewCell
            let comment = viewModel.comments.value?[indexPath.row]
            cell.comment = comment

            return cell
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Comments".L
        }
        return nil
    }

}
