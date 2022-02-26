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
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!

    // MARK: - Properties
    var post: Post? {
        didSet {
            descriptionLabel.text = post?.title
            if !(post?.isFavorite ?? false) {
                imageWidthConstraint.constant = 0
                iconImageView.image = nil
            } else {
                imageWidthConstraint.constant = 32
                iconImageView.image = UIImage(systemName: "star.fill")
                iconImageView.tintColor = UIColor(red: 0.99, green: 0.80, blue: 0.00, alpha: 1.00)
            }
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
