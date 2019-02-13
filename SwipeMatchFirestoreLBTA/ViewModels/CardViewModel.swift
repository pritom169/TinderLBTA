//
//  CardViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/13/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

protocol ProducesCarViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    //We'll define the properties that are view will display/render out!
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}

