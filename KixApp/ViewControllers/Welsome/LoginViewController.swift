//
//  LoginViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 18/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin

protocol LoginControllerDelegate{
    func didFinishLogingIn()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
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
    
    
    let loginButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Log In", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.layer.cornerRadius = 22
            
            return button
        }()
    
    var errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x:0, y:0, width:50, height:21))
        label.numberOfLines = 0
        label.alpha = 0
        label.heightAnchor.constraint(equalToConstant: 55).isActive = true

        return label
    }()
    
    let facebookButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Login with Facebook", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.layer.cornerRadius = 22
            
            return button
        }()
    let InstagramButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Login with Instagram", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
            button.layer.cornerRadius = 22
            
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(fbTapped), for: .touchUpInside)
        InstagramButton.addTarget(self, action: #selector(instaTapped), for: .touchUpInside)
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
    
    @objc fileprivate func handleKeyBoardShow(notification: Notification){
//        if self.emailTextField.isSelected{
//            
//        }
        guard let value =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else{return}
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 40)
        
    }
    
    let goToWelcomePage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToWelcome), for: .touchUpInside)
        return button
        
    }()
    
    @objc fileprivate func handleGoToWelcome(){
            navigationController?.popViewController(animated: true)

        }
    
    lazy var stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,loginButton, errorLabel, facebookButton])
    
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
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
        
    }
    @objc fileprivate func fbTapped() {
       // sender.startAnimation()
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        loginManager.logIn(permissions: [.email, .publicProfile], viewController: self) { (result) in
            
            switch result {
            case .failed(let error):
//                self.fbBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.1) {
//                    self.fbBtn.setTitleColor(#colorLiteral(red: 0.7838708162, green: 0.6377519965, blue: 0.2381356955, alpha: 0.8470588235), for: .normal)
//                    self.fbBtn.setTitle("Facebook".localized(), for: .normal)
//                    self.fbBtn.layer.cornerRadius = self.fbBtn.frame.size.height/2
//
//                }
                print(error)
            case .cancelled:
//                self.fbBtn.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.1) {
//                    self.fbBtn.setTitleColor(#colorLiteral(red: 0.7838708162, green: 0.6377519965, blue: 0.2381356955, alpha: 0.8470588235), for: .normal)
//                    self.fbBtn.setTitle("Facebook".localized(), for: .normal)
//                    self.fbBtn.layer.cornerRadius = self.fbBtn.frame.size.height/2
//
//                }
                
                print("User cancelled login.")
            case .success(let grantedPermissions, _, _):
                print("Logged in!")
                
                if grantedPermissions.contains("email") {
                    self.getFBUserData()
                }
            }
        }
    }
    func getFBUserData(){
        if let _ = AccessToken.current {
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"name, email"])) { httpResponse, result, error   in
                if error != nil {
                    NSLog(error.debugDescription)
                    return
                }
                
                // Handle vars
                if let result = result as? [String:String],
                    let email: String = result["email"],
                    let name:String = result["name"],
                    let fbId: String = result["id"]
                {
                    let imgURLStr = "https://graph.facebook.com/\(fbId)/picture?type=large"
                    //Add code for redirection to home
                    ////Redirection for login after facebook success
                }
                
            }
            connection.start()
        }
        
        
        
        
        
    }
    @objc fileprivate func instaTapped() {
    }
    
    @objc fileprivate func loginTapped() {
        //TODO:Validate text fields
        //Check in there are any errors
        
        //Create cleaned versions
        
        //Signing in the user
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                let controller = SwiperViewController()
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
                self.delegate?.didFinishLogingIn()
            }
        }
    }
}
