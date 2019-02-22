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

//View model is supposed to represent the state of our view

class CardViewModel {
    //We'll define the properties that are view will display/render out!
    
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0{
        didSet{
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    //MARK:: Reactive programming
    
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func addvanceToNextPhoto(){
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(0, imageIndex - 1)
    }
}

