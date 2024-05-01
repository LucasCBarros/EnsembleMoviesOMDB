//
//  UIView+Extension.swift
//  FirebaseLoginPOC
//
//  Created by Lucas C Barros on 2024-04-22.
//

import UIKit

extension UIView {
    
    // Add blur to slide views
    func addBlur(_ alpha: CGFloat = 0.5, style: UIBlurEffect.Style = .extraLight) {
           // create effect
           let effect = UIBlurEffect(style: style)
           let effectView = UIVisualEffectView(effect: effect)
           
           // set boundry and alpha
           effectView.frame = self.bounds
           effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           effectView.alpha = alpha
           
           self.addSubview(effectView)
       }
}

extension UIView {

    // Add animation to slide views
    func slideY(y: CGFloat) {

        let xPosition = self.frame.origin.x

        let height = self.frame.height
        let width = self.frame.width

        UIView.animate(withDuration: 1.0, animations: {
            self.frame = CGRect(x: xPosition, y: y, width: width, height: height)
            self.layoutIfNeeded()
        })
    }
}
