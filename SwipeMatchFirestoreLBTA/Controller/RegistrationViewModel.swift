//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/14/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    
    fileprivate func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObsever?(isFormValid)
    }
    //Reactive programming
    var isFormValidObsever: ((Bool) -> ())?
}
