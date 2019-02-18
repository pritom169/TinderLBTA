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
    var uid: String?
    
    init(dictionary: [String: Any]) {
        //We will initialize our user here!
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String ??  ""
        self.uid = dictionary["imageUrl1"] as? String ??  ""
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
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
