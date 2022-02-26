//
//  PostTableViewCell.swift
//  PostFeed
//
//  Created by Andres Rojas on 26/02/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Properties
    var post: Post? {
        didSet {
            descriptionLabel.text = post?.title
        }
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {
        accessoryType = .disclosureIndicator
    }

}
