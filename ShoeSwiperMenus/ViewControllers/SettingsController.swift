//
//  SettingsController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 11/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class SettingsController: UITableViewController {

    var delegate: SettingsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    }
    
    class HeaderLabel: UILabel{
        override func drawText(in rect: CGRect){
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    
    
    

    // MARK: - Table view data source
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
    
    
    var user: ActualUser?
    
    fileprivate func fetchCurrentUser(){
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").whereField("uid",isEqualTo: userUID).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            
            guard let dictionary = querySnapshot!.documents.first?.data() else { return }
            self.user = ActualUser(dictionary: dictionary)
            self.tableView.reloadData()
            
            }
    }
    }
    
   
    
    @objc fileprivate func handleLogout(){
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 6 {
//            let cell = LogoutTableViewCell(style: .default, reuseIdentifier: nil, action: #selector(handleCancel))
//            return cell
//            let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//            let logoutView = UIView(frame: rect)
            
            
            let logoutButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle("Log Out", for: .normal)
                button.setTitleColor(#colorLiteral(red: 0.7137254902, green: 0.09411764706, blue: 0.1529411765, alpha: 1), for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
                button.layer.borderWidth = 2
                button.layer.borderColor = #colorLiteral(red: 0.7137254902, green: 0.09411764706, blue: 0.1529411765, alpha: 1)
                button.layer.cornerRadius = 22
                button.tintColor = UIColor.black
                button.heightAnchor.constraint(equalToConstant: 55).isActive = true
                button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
                
            return button
            }()
//            logoutView.addSubview(logoutButton)
////            logoutView.frame.insetBy(dx: 10, dy: 10)
//
            return logoutButton
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 0:
            headerLabel.text = "First Name"
        case 1:
            headerLabel.text = "Last Name"
        case 2:
            headerLabel.text = "Shoe Size"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Gender"
        default:
            headerLabel.text = "Price Range"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 6 {
            return 65
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 6 ? 0 : 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider){
        //I want to update the minimum of my price change cell.
        let indexPath = IndexPath(row:0, section: 5)
        let priceRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        priceRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        self.user?.minSeekingPrice = Int(slider.value)
        if priceRangeCell.maxSlider.value < priceRangeCell.minSlider.value{
            priceRangeCell.maxSlider.value = priceRangeCell.minSlider.value
            priceRangeCell.maxLabel.text = "Max: \(Int(priceRangeCell.maxSlider.value))"
            self.user?.maxSeekingPrice = Int(priceRangeCell.maxSlider.value)
        }
    }
    @objc fileprivate func handleMaxAgeChange(slider: UISlider){
        let indexPath = IndexPath(row:0, section: 5)
        let priceRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        priceRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        self.user?.maxSeekingPrice = Int(slider.value)
        if priceRangeCell.minSlider.value > priceRangeCell.maxSlider.value {
            priceRangeCell.minSlider.value = priceRangeCell.maxSlider.value
            priceRangeCell.minLabel.text = "Min: \(Int(priceRangeCell.minSlider.value))"
            self.user?.minSeekingPrice = Int(priceRangeCell.minSlider.value)
        }

    }
    
    static let defaultMinSeekingPrice = 20
    static let defaultMaxSeekingPrice = 300
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Price range cell
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            //we need to setup the labels on our cell here:
            ageRangeCell.minLabel.text = "Min: \(user?.minSeekingPrice ?? SettingsController.defaultMinSeekingPrice)"
            ageRangeCell.maxLabel.text = "Max: \(user?.maxSeekingPrice ?? SettingsController.defaultMaxSeekingPrice)"
            ageRangeCell.minSlider.value = Float(user?.maxSeekingPrice ?? SettingsController.defaultMinSeekingPrice)
            ageRangeCell.maxSlider.value = Float(user?.maxSeekingPrice ?? SettingsController.defaultMaxSeekingPrice)
            if let minPrice = user?.minSeekingPrice {
                ageRangeCell.minSlider.value = Float(minPrice)
            }
            if let maxPrice = user?.maxSeekingPrice{
                ageRangeCell.maxSlider.value = Float(maxPrice)
            }
            
            return ageRangeCell
        }
        
//        if indexPath.section == 6 {
//
//        }
        
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 0:
            cell.textField.placeholder = "Enter First Name"
            cell.textField.text = user?.firstName
            cell.textField.addTarget(self, action: #selector(handleFirstNameChange), for: .editingChanged)

        case 1:
            cell.textField.placeholder = "Enter Last Name"
            cell.textField.text = user?.lastName
            cell.textField.addTarget(self, action: #selector(handleLastNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Shoe Size"
            cell.textField.text = String(user?.shoeSize ?? 24)
            cell.textField.addTarget(self, action: #selector(handleShoeSizeChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age{
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        
        default:
            cell.textField.placeholder = "Enter Gender"
            cell.textField.text = user?.gender
            cell.textField.addTarget(self, action: #selector(handleGenderChange), for: .editingChanged)
        }
        return cell
    }
    
    @objc fileprivate func handleFirstNameChange(textField: UITextField){
        self.user?.firstName = textField.text
    }
    @objc fileprivate func handleLastNameChange(textField: UITextField){
        self.user?.lastName = textField.text
    }
    @objc fileprivate func handleAgeChange(textField: UITextField){
        self.user?.age = Int(textField.text ?? "")
    }
    @objc fileprivate func handleShoeSizeChange(textField: UITextField){
        self.user?.shoeSize = Int(textField.text ?? "")
       }
    @objc fileprivate func handleGenderChange(textField: UITextField){
        self.user?.gender = textField.text
    }
    
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    
    @objc fileprivate func handleSave(){
        print("Saving our data!!")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String: Any] = [
            "uid":uid,
            "firstName": user?.firstName ?? "",
            "lastName": user?.lastName ?? "",
            "age": user?.age ?? -1,
            "shoeSize": user?.shoeSize ?? -1,
            "minSeekingPrice": user?.minSeekingPrice ?? 20,
            "maxSeekingPrice": user?.maxSeekingPrice ?? 200]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData, merge: true){ (err)
            in
            hud.dismiss()
            if let err = err{
                print("Fail to save user settings: ", err)
                return
            }
            print("Finished saving user info!")
            
            self.dismiss(animated: true, completion: {
                print("Dismissal complete!")
                self.delegate?.didSaveSettings()
            })
            
        }
    }
}


