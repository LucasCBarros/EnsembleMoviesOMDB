//
//  UIView+Extension.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-07.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    init() {
        super.init(frame: CGRect.zero)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.clear.cgColor]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.darkGray.cgColor,
                                UIColor.gray.cgColor,
                                UIColor.clear.cgColor]
    }
}
