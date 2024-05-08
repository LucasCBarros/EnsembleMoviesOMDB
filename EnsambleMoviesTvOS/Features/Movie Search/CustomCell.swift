//
//  CustomCell.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-07.
//

import UIKit

class CustomCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let containerView = UIImageView()
    var delegate: MovieSearchListTvViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubviews([containerView])
        containerView.addSubviews([imageView, titleLabel])
        
        containerView
            .sizeToSuperview()
        imageView
            .sizeToSuperview()
        titleLabel
            .widthToSuperview()
            .bottomToSuperview()
        
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 5.0
        imageView.layer.cornerRadius = 25
        titleLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.delegate?.updateImageView(with: self.tag)
        if context.nextFocusedView == self {
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } else {
            containerView.layer.borderColor = UIColor.clear.cgColor
            containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
