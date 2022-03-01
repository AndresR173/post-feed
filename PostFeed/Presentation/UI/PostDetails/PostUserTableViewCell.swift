//
//  UserTableViewCell.swift
//  PostFeed
//
//  Created by Andres Rojas on 1/03/22.
//

import UIKit

class PostUserTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var nameLabel = UILabel()
        .with { label in
            label.text = "Title".L
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
        }

    private lazy var emailLabel = UILabel()
        .with { label in
            label.text = "Description".L
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
        }

    private lazy var phoneLabel = UILabel()
        .with { label in
            label.numberOfLines = 3

        }

    private lazy var websiteLabel = UILabel()
        .with { label in
            label.numberOfLines = 0
        }

    private lazy var stackView = UIStackView()
        .with { stackView in
            stackView.axis = .vertical
            stackView.spacing = 8

            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(emailLabel)
            stackView.addArrangedSubview(phoneLabel)
            stackView.addArrangedSubview(websiteLabel)
        }

    var user: User? {
        didSet {
            nameLabel.text = user?.name
            emailLabel.text = user?.email
            phoneLabel.text = user?.phone
            websiteLabel.text = user?.website
        }
    }

    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension PostUserTableViewCell {
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
