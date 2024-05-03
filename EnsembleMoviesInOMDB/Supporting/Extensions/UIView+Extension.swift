//
//  UIView+Extension.swift
//  FirebaseLoginPOC
//
//  Created by Lucas C Barros on 2024-04-22.
//

import UIKit

extension UIView {

    // Add animation to slide views
    func hideSlideY(yAxis: CGFloat, shouldHide: Bool) {

        let xPosition = self.frame.origin.x

        let height = self.frame.height
        let width = self.frame.width

        UIView.animate(withDuration: 1.0, animations: {
            self.frame = CGRect(x: xPosition, y: yAxis, width: width, height: height)
            self.layoutIfNeeded()
        })
        // Hide view not be accessible via voice-over
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = shouldHide ? 0 : 1 }) { _ in
            self.isHidden = shouldHide
        }
    }
}
