//
//  MatchView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/25/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit

class MatchView: UIView {
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView:UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "3 6"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
    return imageView
    }()
    
    fileprivate let cardUserImageView:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "3 8"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        
        setupLayout()
        
        setupAnimation()
    }
    
    fileprivate func setupLayout(){
        addSubview(itsAMatchImageView)
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        
        let imageWidth: CGFloat = 140
        
        itsAMatchImageView.anchor(top: nil, leading: nil,
                                  bottom: descriptionLabel.topAnchor, trailing: nil,
                                  padding: .init(top: 0, left: 0, bottom: 16, right: 0),
                                  size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: self.leadingAnchor,
                                bottom: currentUserImageView.topAnchor, trailing: trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 32, right: 0),
                                size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil,
                                    bottom: nil, trailing: centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 16),
                                    size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.layer.cornerRadius = imageWidth / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor,
                                 bottom: nil, trailing: nil,
                                 padding: .init(top: 0, left: 16, bottom: 0, right: 0),
                                 size: .init(width: imageWidth, height: imageWidth))
        
        cardUserImageView.layer.cornerRadius = imageWidth / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil,
                                 trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48),
                                 size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor,
                                 bottom: nil, trailing: sendMessageButton.trailingAnchor,
                                 padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 0, height: 60))
    }
    
    fileprivate func setupAnimation(){
        
        let angle = 30 * CGFloat.pi / 180
        //starting postition
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            .concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            .concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        //keyframe animations for segmented animation
        UIView.animateKeyframes(withDuration: 1.2, delay: 0,
                                options: .calculationModeCubic, animations: {
                                    
                                    //Animation 1 - translation back to original position
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.45, animations: {
                                                        self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                                                        self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
                                    })
                                    
                                    //Animation 2 - rotation
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0.4, animations: {
                                                self.currentUserImageView.transform = .identity
                                                self.cardUserImageView.transform = .identity
                                    })
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1, options: .curveEaseOut,
                       animations: {
                        self.sendMessageButton.transform = .identity
                        self.keepSwipingButton.transform = .identity
        })
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView(){
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 1, options: .curveEaseOut,
                       animations: {
                       self.visualEffectView.alpha = 1
        }) { (_) in
    
        }
    }
    
    @objc fileprivate func handleTapDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                       initialSpringVelocity: 1, options: .curveEaseOut,
                       animations: {
                        self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.65, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                        self.sendMessageButton.transform = .identity
                        self.keepSwipingButton.transform = .identity
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
