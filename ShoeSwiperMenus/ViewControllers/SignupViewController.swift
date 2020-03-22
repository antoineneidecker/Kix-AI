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

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    
    
    //Check that all fields have been filled out. If they have, return nil. Else return error.
    func validateFields() -> String?{
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure the password is at least 8 characters long, contains a spectial character and a number."
        }
        
        
        return nil
    }
    
    @IBAction func signupTapped(_ sender: Any) {
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
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors:
                if err != nil {
                    
                    self.showError("Error creating the user!")
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName" : firstName, "lastName" : lastName, "email" : email, "uid" : result!.user.uid]) { (error) in
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
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    func setupElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
        
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signupButton)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
