//
//  PostCommentTableViewCell.swift
//  PostFeed
//
//  Created by Andres Rojas on 1/03/22.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
    // MARK: - Properties

    private lazy var commentLabel = UILabel()
        .with { label in
            label.numberOfLines = 0
            label.text = "Title".L
        }

    private lazy var authorLabel = UILabel()
        .with { label in
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
        }

    private lazy var stackView = UIStackView()
        .with { stackView in
            stackView.axis = .vertical
            stackView.spacing = 8

            stackView.addArrangedSubview(commentLabel)
            stackView.addArrangedSubview(authorLabel)
        }

    private lazy var divider = UIView()
        .with { view in
            view.backgroundColor = .gray
        }

    var comment: Comment? {
        didSet {

            commentLabel.text = comment?.body
            authorLabel.text = comment?.email
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

private extension PostCommentTableViewCell {
    func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(divider)
        selectionStyle = .none

        NSLayoutConstraint.activate( [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
