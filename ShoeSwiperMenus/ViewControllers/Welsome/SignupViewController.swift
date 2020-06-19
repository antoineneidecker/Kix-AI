//
//  SignupViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 18/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignupViewController: UIViewController {

    
    
    let firstNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.placeholder = "First Name"
        tf.backgroundColor = .white
        
        return tf
    }()
    let lastNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.placeholder = "Last Name"
        tf.backgroundColor = .white
        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 22
        
//        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signupTapped)))
        return button
    }()
    
    
    
    
    var errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x:0, y:0, width:50, height:21))
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
    
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
        
    }
    
    
    //Check that all fields have been filled out. If they have, return nil. Else return error.
    func validateFields() -> String?{
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure the password is at least 8 characters long."
        }
        return nil
    }
    
    @objc func handleUserButton(){
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.modalPresentationStyle = .fullScreen
        self.present(welcomeViewController, animated: true)
    }
    
    
    @objc func signupTapped() {
        // Validate the fields
        print("Button Tapped!!!")
        let error = validateFields()
        if error != nil {
            // there's something wromg with the fields.
            showError(error!)
        }
            
        // Create the user
        else{
            // Create cleaned versions of the text fields.
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors:
                if err != nil {
                    self.showError("Error creating the user!")
                }
                else{
                    let db = Firestore.firestore()
                    let data: [String: Any] = ["firstName" : firstName,
                        "lastName" : lastName,
                        "email" : email,
                        "uid" : result!.user.uid,
                        "age" : 24,
                        "minSeekingPrice": SettingsController.defaultMinSeekingPrice,
                        "maxSeekingPrice": SettingsController.defaultMaxSeekingPrice
                    ]
                    db.collection("users").document(result!.user.uid).setData(data) { (error) in
                        if error != nil{
                            self.showError("DB couldn't save credentials...")
                        }
                    }
                    // Transition to home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func transitionToHome(){
        let homeViewController = SwiperViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [firstNameTextField,lastNameTextField, emailTextField, passwordTextField,signupButton, errorLabel])
    
    let goToWelcomePage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToWelcome), for: .touchUpInside)
        return button
        
    }()
    
    @objc fileprivate func handleGoToWelcome(){
//        let welcomeController = WelcomeViewController()
//        print("Intercepting")
        navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    fileprivate func setupLayout() {

        view.backgroundColor = .gray
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(goToWelcomePage)
        goToWelcomePage.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
    fileprivate func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyBoardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc fileprivate func handleKeyBoardShow(notification: Notification){
        guard let value =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else{return}
        let keyboardFrame = value.cgRectValue
        
        
        //let's figure out how tall the gap is from the bottom of the sign in button to the button of the screen
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 40)
        
    }

}
