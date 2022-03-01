//
//  PostDetailViewController.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import UIKit
import Lottie

class PostDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let viewModel: PostDetailsViewModelProtocol
    private lazy var animationView = AnimationView()

    private let descriptionCellIdentifier = String(describing: PostDescriptionTableViewCell.self)

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
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostDescriptionTableViewCell.self, forCellReuseIdentifier: descriptionCellIdentifier )
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none

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
            } else {
                strongSelf.tableView.fadeOut()
            }

        }

    }
}

// MARK: - TableView data source & delegate

extension PostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.post.value == nil ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier,
                                                 for: indexPath) as! PostDescriptionTableViewCell
        cell.post = viewModel.post.value!

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.post.value == nil ? 0 : 1
    }

}
