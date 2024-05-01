//
//  UIView+Extension.swift
//  FirebaseLoginPOC
//
//  Created by Lucas C Barros on 2024-04-22.
//

import UIKit

extension UIView {
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
