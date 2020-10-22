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
import JGProgressHUD
import BetterSegmentedControl


class SignupViewController: UIViewController {
    
    let datePicker = UIDatePicker()


    func setDatePicker() {
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        bdayPicker.inputAccessoryView = toolbar
        bdayPicker.inputView = datePicker
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        bdayPicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ecoFriendlyIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    @objc func handleInfoDBButton(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Find shoes similar \nto your age group"
        hud.indicatorView = nil
        hud.show(in: view)
        hud.dismiss(afterDelay: 1.5)
    }
    
    @objc func handleInfoEmailButton(){
           let hud = JGProgressHUD(style: .dark)
           hud.textLabel.text = "We won't email you"
           hud.indicatorView = nil
           hud.show(in: view)
           hud.dismiss(afterDelay: 1.5)
       }
    
    var gender = "Woman"
    
    let firstNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.placeholder = "First Name"
        tf.backgroundColor = .white
        tf.font = UIFont(name: "Roboto", size: 20)
        
        return tf
    }()
    
    
    let lastNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.placeholder = "Last Name"
        tf.backgroundColor = .white
        tf.rightView = .init(backgroundColor: .black)
        tf.rightViewMode = .always
        tf.font = UIFont(name: "Roboto", size: 20)
        return tf
    }()
    
//    @IBOutlet weak var control1: BetterSegmentedControl!
//
//    control1.segments = LabelSegment.segments(withTitles: ["Recent", "Nearby", "All"], normalFont: UIFont(name: "HelveticaNeue-Light", size: 13.0)!, selectedFont: UIFont(name: "HelveticaNeue-Medium", size: 13.0)!)
    
    
    let bdayPicker: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.placeholder = "Birthday"
        tf.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Info-Signup").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(tf.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(handleInfoDBButton), for: .touchUpInside)

        tf.rightView = button
        tf.rightViewMode = .always
        tf.font = UIFont(name: "Roboto", size: 20)

        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Info-Signup").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(tf.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(handleInfoEmailButton), for: .touchUpInside)

        tf.rightView = button
        tf.rightViewMode = .always
        tf.font = UIFont(name: "Roboto", size: 20)

        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 20)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.font = UIFont(name: "Roboto", size: 20)
        return tf
    }()
    
    
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto", size: 20)
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
    
    
    var genderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x:0, y:0, width:50, height:21))
        label.numberOfLines = 0
        label.alpha = 0
        label.text = "Interested in shoes for: "
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setDatePicker()
        
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
    
    
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
        
    }
    
    
    fileprivate func findAge() -> String {
        
        let now = Date()
        let birthday: Date = datePicker.date
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        let ageString = String(age)
        
        return ageString
    }
    
    fileprivate func checkAge(age: String) -> Bool {
        let ageInt = Int(age)
        if(ageInt! < 12){
            return false
        }
        return true
    }
    
    //Check that all fields have been filled out. If they have, return nil. Else return error.
    func validateFields() -> String?{
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || bdayPicker.text == ""{
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
            let dob = bdayPicker.text
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = findAge()
            let oldEnough = checkAge(age: age)
            
            if(!oldEnough){
                showError("You are a little young, comeback in a few years!")
                return
            }
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors:
                if err != nil {
                    self.showError("Error creating the user!")
                }
                else{
                    let db = Firestore.firestore()
                    print("OKAYYYY you can come in!")
                    print(result!.user.uid)
                    let data: [String: Any] = ["firstName" : firstName,
                        "lastName" : lastName,
                        "email" : email,
                        "uid" : result!.user.uid,
                        "dob" : dob!,
                        "age" : age,
                        "gender": self.gender,
                        "minSeekingPrice": SettingsController.defaultMinSeekingPrice,
                        "maxSeekingPrice": SettingsController.defaultMaxSeekingPrice,
                    ]
                    db.collection("users").document(result!.user.uid).setData(data) { (error) in
                        if error != nil{
                            self.showError("DB couldn't save credentials...")
                        }
                    }
                    self.transitionToOnboarding()
                    
                }
            }
        }
    }
    
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func transitionToOnboarding(){
        let onboarding = OnboardingViewController()
        onboarding.modalPresentationStyle = .fullScreen
        self.present(onboarding, animated: true)
    }
    
    
    lazy var stackView = UIStackView(arrangedSubviews: [firstNameTextField,lastNameTextField, bdayPicker, emailTextField, passwordTextField, signupButton, errorLabel])
    
    lazy var selectorStackView = UIStackView(arrangedSubviews: [genderLabel])
    
    
    let goToWelcomePage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        button.addTarget(self, action: #selector(handleGoToWelcome), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc fileprivate func handleGoToWelcome(){
//        let welcomeController = WelcomeViewController()
//        print("Intercepting")
        navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
    }
    
    fileprivate func setupSelector(belowView: UIStackView) -> BetterSegmentedControl{
        
        let widthRect = view.frame.size.width - 80
        let heightRect = CGFloat(50)
        let xrect = belowView.frame.maxX + 40
        let yrect = belowView.frame.origin.y + 90
       
        
        let selector : BetterSegmentedControl = {
            
            let slider = BetterSegmentedControl(
            frame: CGRect(x: xrect, y: yrect, width: widthRect, height: heightRect),
            segments: LabelSegment.segments(withTitles: ["Woman", "Man", "Both"],
            normalFont: UIFont(name: "Roboto", size: 20)!,
            normalTextColor: .lightGray,
            selectedFont: UIFont(name: "Roboto", size: 20)!,
            selectedTextColor: .white),
            index: 1,
            options: [.backgroundColor(.darkGray),
                      .indicatorViewBackgroundColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1))])
            
            return slider
        }()
        selector.setIndex(0)
        return selector
    }
    
    
    var sliderSelector: BetterSegmentedControl!
    
    fileprivate func setupLayout() {
        
        
        view.backgroundColor = .gray
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        
        
        
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        sliderSelector = setupSelector(belowView: stackView)
        view.addSubview(sliderSelector)
        sliderSelector.addTarget(self, action: #selector(sliderSelectorChanged), for: .valueChanged)
        
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
    @objc fileprivate func sliderSelectorChanged(){
        
        switch sliderSelector.index {
        case 0:
            gender = "Woman"
        case 1:
            gender = "Man"
        default:
            gender = "Both"
        }
        print(gender)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc fileprivate func handleKeyBoardShow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else{return}
        let keyboardFrame = value.cgRectValue
        
        
        //let's figure out how tall the gap is from the bottom of the sign in button to the button of the screen
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 40)
        
    }

}
