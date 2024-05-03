//
//  UIViewController+Extension.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-05-02.
//

import UIKit

extension UIViewController {
    func popAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
