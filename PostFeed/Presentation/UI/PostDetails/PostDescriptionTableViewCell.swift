//
//  PostDescriptionTableViewCell.swift
//  PostFeed
//
//  Created by Andres Rojas on 28/02/22.
//

import UIKit

class PostDescriptionTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var cellTitleLabel = UILabel()
        .with { label in
            label.text = "Title".L
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
        }

    private lazy var cellDescriptionLabel = UILabel()
        .with { label in
            label.text = "Description".L
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
        }

    private lazy var postTitleLabel = UILabel()
        .with { label in
            label.numberOfLines = 3
            label.accessibilityIdentifier = "postDetails.title"

        }

    private lazy var postDescriptionLabel = UILabel()
        .with { label in
            label.numberOfLines = 0
            label.accessibilityIdentifier = "postDetails.description"
        }

    private lazy var stackView = UIStackView()
        .with { stackView in
            stackView.axis = .vertical
            stackView.spacing = 8

            stackView.addArrangedSubview(cellTitleLabel)
            stackView.addArrangedSubview(postTitleLabel)
            stackView.addArrangedSubview(cellDescriptionLabel)
            stackView.addArrangedSubview(postDescriptionLabel)
        }

    var post: Post? {
        didSet {
            postTitleLabel.text = post?.title
            postDescriptionLabel.text = post?.body
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension PostDescriptionTableViewCell {
    func setupUI() {
        contentView.addSubview(stackView)
        selectionStyle = .none

        NSLayoutConstraint.activate( [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
