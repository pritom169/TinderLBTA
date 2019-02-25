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
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        //We will initialize our user here!
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ??  ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes:
            [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A "
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes:
            [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not available"
        
        attributedText.append(NSAttributedString(string: "\n  \(professionString)", attributes:
            [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageURLs = [String]()
        if let url = imageUrl1{ imageURLs.append(url)}
        if let url = imageUrl2{ imageURLs.append(url)}
        if let url = imageUrl3{ imageURLs.append(url)}
        
        return CardViewModel(uid: self.uid ?? "", imageNames: imageURLs, attributedString: attributedText, textAlignment: .left)
    }
}
