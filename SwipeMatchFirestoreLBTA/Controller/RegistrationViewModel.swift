//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/14/19.
//  Copyright © 2019 bs137. All rights reserved.
//
import Foundation
import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
//    var image: UIImage? {
//        didSet{
//            imageObserver?(image)
//        }
//    }
//
//    var imageObserver: ((UIImage?) -> ())?
    
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    
    fileprivate func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
//        isFormValidObsever?(isFormValid)
    }
    
    var bindableIsFormValid = Bindable<Bool>()
    
    //Reactive programming
//    var isFormValidObsever: ((Bool) -> ())?
}
