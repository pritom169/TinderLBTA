//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/14/19.
//  Copyright © 2019 bs137. All rights reserved.
//
import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false &&
            password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }

    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        bindableIsRegistering.value = true
        guard let email = email, let password = password else {return}
            Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
                
                if let err = err {
                    completion(err)
                    return
                }
                print("Successfully registered user:", res?.user.uid ?? "")
                self.saveImageToFirebase(completion: completion)
            }
        }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()){
        let filename = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        reference.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Finish uploading image to storage!")
            reference.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                print("Downlaod url of our image is:", url?.absoluteString ?? "")
                //store the download URL into Firestore into next lesson
                self.saveInfoToFireStore(imageUrl: url?.absoluteString ?? "", completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFireStore(imageUrl: String ,completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String : Any] = ["fullName": fullName ?? "",
                       "uid": uid,
                       "imageUrl1": imageUrl,
                       "age": 18,
                       "minSeekingAge": SettingsController.defaultMinSeekingAge,
                       "maxSeekingAge": SettingsController.defaultMaxSeekingAge
            ]
        Firestore.firestore().collection("users").document(uid).setData(docData, completion: { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        })
    }
}
