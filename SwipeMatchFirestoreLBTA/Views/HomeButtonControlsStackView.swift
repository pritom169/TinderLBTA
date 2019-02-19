//
//  HomeButtonControlsStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/12/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

class HomeButtonControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "3 1"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "3 2"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "3 3"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "3 4"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "3 5"))


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshButton,dislikeButton,superLikeButton,likeButton,specialButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
        
        subviews.forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
