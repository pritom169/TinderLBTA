//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/12/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeButtonControlsStackView()
    
    
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
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    //MARK:: Fileprivate
    
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    fileprivate func setupFirestoreUserCards(){
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }
    }
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        //This line of code brings the card view to the front!
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        //We will use pagination here to page through 2 users at a time
        let query = Firestore.firestore().collection("users").order(by: "uid").start(at: [lastFetchedUser?.uid ?? ""])
            .limit(to: 2)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            hud.dismiss()
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
//            self.setupFirestoreUserCards()
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
}

