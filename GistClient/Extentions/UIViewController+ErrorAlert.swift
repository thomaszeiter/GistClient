//
//  UIViewController+ErrorAlert.swift
//  GistClient
//
//  Created by Tanya Petrenko on 09.08.2022.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(_ message: String, tryAgainAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Error has occurred",
            message: message,
            preferredStyle: .alert)

        let tryAgainAction = UIAlertAction(title: "Try again?", style: .default) { _ in
            tryAgainAction()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(cancelAction)
        alert.addAction(tryAgainAction)
        present(alert, animated: true)
    }
}
