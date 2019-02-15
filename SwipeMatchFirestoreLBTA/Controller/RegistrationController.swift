//
//  RegistrationViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by bs137 on 2/14/19.
//  Copyright © 2019 bs137. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
//        registrationViewModel.image = image
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    
    //UI Components
    
    let selectedPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField){
        
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        }else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    let registerButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkGray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismiss()
        print("Register our user in firebase Auth!")
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            
            print("Successfully registered user:", res?.user.uid ?? "")
        }
    }
    
    fileprivate func showHUDWithError(error: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObserver()
        setupTapGesture()
        setupRegistraionViewModelObserver()
    }
    
    //MARK:: Private
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer(){
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        //Make sure to use CG Color. Because without CGColor it won't work!
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    lazy var verticalStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews:[fullNameTextField,emailTextField,
                            passwordTextField, registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews:
        [selectedPhotoButton,
         verticalStackView])
    
    //This function allows the gradient view to be in proper form even when the phone is in horizontal mode.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        selectedPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self) //Otherwise we'll have a retain cycle.
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification){
        //how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        
        //let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        
    }
    
    @objc fileprivate func handleKeyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
                        self.view.transform = .identity
        })
    }
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true) //dismisses keyboard
        UIView.animate(withDuration: 0.5) {
        }
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistraionViewModelObserver(){
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self]
            (isFormValid) in
            
            guard let isFormValid = isFormValid else {return}
            self.registerButton.isEnabled = isFormValid
            
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        registrationViewModel.bindableImage.bind { [unowned self] (img) in
             self.selectedPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        //        registrationViewModel.isFormValidObsever = { [unowned self]
        //            (isFormValid) in
        //            print("Form is changing, is it valid?" ,isFormValid)
        //
        //            self.registerButton.isEnabled = isFormValid
        //
        //            if isFormValid {
        //                self.registerButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        //                self.registerButton.setTitleColor(.white, for: .normal)
        //            } else {
        //                self.registerButton.backgroundColor = .lightGray
        //                self.registerButton.setTitleColor(.gray, for: .normal)
        //            }
        //        }
    }
}
