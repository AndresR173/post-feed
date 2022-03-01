//
//  ViewController+Extensions.swift
//  PostFeed
//
//  Created by Andres Rojas on 27/02/22.
//

import UIKit

extension UIViewController {

    func showDeleteDialog(title: String, message: String, onDelete: @escaping () -> Void) {
        let dialogMessage = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .actionSheet)

        let delete = UIAlertAction(title: "Delete".L,
                                   style: .destructive,
                                   handler: { _ -> Void in
            onDelete()
        })
        delete.accessibilityIdentifier = "delete.alertAction"
        let cancel = UIAlertAction(title: "Cancel".L,
                                   style: .cancel
        )
        cancel.accessibilityIdentifier = "cancel.alertAction"

        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        present(dialogMessage, animated: true, completion: nil)
    }
}
