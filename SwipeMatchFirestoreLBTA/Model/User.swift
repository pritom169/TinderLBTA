//
//  User.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/13/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

struct User:ProducesCarViewModel {
    //Defininf our properties for the model layer!
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes:
            [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "  \(age)", attributes:
            [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n  \(profession)", attributes:
            [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageName], attributedString: attributedText, textAlignment: .left)
    }
}
