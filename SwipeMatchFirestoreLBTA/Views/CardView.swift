//
//  CardView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/13/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo()
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet{
            
            let imageName = cardViewModel.imageNames.first ?? ""
            
            //we're currently passing our url for image. So instead of showing the url the library will show the image.
            if let url = URL(string: imageName){
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self](idx, imageURL) in
            print("Changing photo from view model!")
            if let url = URL(string: imageURL ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    
    //Encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "34"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    //Configurations
    fileprivate let threshold: CGFloat = 80
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
//    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        print("Handling tap and cycling photos!")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto{
            cardViewModel.addvanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "33").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo(){
        print("Present User Details page!")
        delegate?.didTapMoreInfo()
        
        //Heck solution: Becasue we don't want to deal with controller codes inside a view class
        
        
//        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        let userDetailsController = UIViewController()
//        userDetailsController.view.backgroundColor = .yellow
//        rootViewController?.present(userDetailsController, animated: true)
        
        //Using a delegate instead, much more stronger solution
    }
    
    fileprivate func setupLayout() {
        //Custom drawing mode
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        //add a gradient layer somehow
        setupGradientLayer()
        addSubview(informationLabel)
        
        informationLabel.anchor(top: nil, leading: leadingAnchor,
                                bottom: bottomAnchor, trailing: trailingAnchor,
                                padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil,
                              bottom: bottomAnchor, trailing: trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 16, right: 16),
                              size: .init(width: 44, height: 44))
    }
    
    fileprivate let barsStackView = UIStackView()
    
    
    fileprivate func setupBarsStackView(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 8, left: 8, bottom: 8, right: 8),
                             size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGradientLayer() {
        //how we can draw a gradient using swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        //inn here you know what you CardView frame will be
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
            
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        //Rotation
        //some not that scary math here to convert radians to degress
        let degrees : CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x)>threshold
        
        
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1,
                       options: .curveEaseOut, animations: {
                        if shouldDismissCard {
                            self.frame = CGRect(x: 600 * translationDirection, y: 0,
                                                width: self.frame.width, height: self.frame.height)
                        }else {
                            self.transform = .identity
                        }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
