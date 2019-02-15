//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/12/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeButtonControlsStackView()
    
    
//    let cardViewModels: [CardViewModel] = {
//       let producers = [
//        User(name: "George", age: 57, profession: "Actor", imageNames: ["cluny", "cluny-2", "cluny-3" ]),
//        User(name: "Angelina", age: 43, profession: "Actress", imageNames: ["angelina", "angelina-2", "angelina-3"]),
//        Advertiser(title: "Slide out Menu", brandName: "Let's build that app", posterPhotoNames: "iPhoneX")
//        ] as [ProducesCarViewModel]
//
//
//        let viewModels = producers.map({return $0.toCardViewModel()})
//        return viewModels
//    }()

    
    var cardViewModels = [CardViewModel]()  //empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
        fetchUsersFromFirestore()
    }
    
    @objc func handleSettings() {
        let registrationViewController = RegistrationController()
        present(registrationViewController, animated: true)
    }
    
    //MARK:: Fileprivate
    
    fileprivate func setupDummyCards(){
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
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
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                print(user.name, user.imageNames)
            })
            self.setupDummyCards()
        }
    }
}

