//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/12/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeButtonControlsStackView()
    
    
    let cardViewModels: [CardViewModel] = {
       let producers = [
        User(name: "George", age: 57, profession: "Actor", imageName: "cluny"),
        User(name: "Angelina", age: 43, profession: "Actress", imageName: "angelina"),
        Advertiser(title: "Slide out Menu", brandName: "Let's build that app", posterPhotoNames: "iPhoneX")
        ] as [ProducesCarViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards(){
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            
//            cardView.imageView.image = UIImage(named: cardViewModel.imageName)
//            cardView.informationLabel.attributedText = cardViewModel.attributedString
//            cardView.informationLabel.textAlignment = cardViewModel.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
    }
    
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        //This line of code brings the card view to the front!
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

