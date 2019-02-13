//
//  Advertiser.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/13/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCarViewModel {
    let title: String
    let brandName: String
    let posterPhotoNames: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes:
            [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedString.append(NSAttributedString(
            string: "\n" + brandName, attributes: [.font:
                UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageNames: [posterPhotoNames], attributedString: attributedString,
                             textAlignment: .center)
    }
}
