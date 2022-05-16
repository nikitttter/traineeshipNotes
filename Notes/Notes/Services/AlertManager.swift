//
//  AlertManager.swift
//  Notes
//
//  Created by Nikita Yakovlev on 16.05.2022.
//

import UIKit

class AlertManager {
    static func showErrorAlert(
        from view: UIViewController,
        text: String,
        animated: Bool = false
    ) {
        let alert = UIAlertController(
            title: NSLocalizedString("error", comment: ""),
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        view.present(alert, animated: animated)
    }
}
