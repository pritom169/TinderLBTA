//
//  PhotoController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/22/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "george"))
    //proview an initializer that takes in a URL instead of an image.
    init(imageUrl: String) {
        if let url = URL(string: imageUrl){
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
