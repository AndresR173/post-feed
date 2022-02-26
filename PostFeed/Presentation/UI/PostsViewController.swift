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

}

// MARK: - Helper Methods

private extension PostsViewController {

    func setupUI() {
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)

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

            if let posts = posts {
                strongSelf.tableView.fadeIn()
            } else {
                strongSelf.tableView.fadeOut()
            }

        }

    }
}

// MARK: - Tableview data source and delegate
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
