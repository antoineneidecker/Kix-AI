//
//  SwiperViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SwiperViewController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = SwipeBottomControlsUIStackView()
    
    var cardViewModels = [CardViewModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.userButton.addTarget(self, action: #selector(handleUserButton), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil{
            let loginController = LoginViewController()
            loginController.delegate = self
            let welcomeController = WelcomeViewController()
            let navController = UINavigationController(rootViewController: welcomeController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
       }
    func didFinishLogingIn() {
        fetchCurrentUser()
    }
    
    
    fileprivate var user: ActualUser?
    fileprivate var hud = JGProgressHUD(style: .dark)
    
    fileprivate func fetchCurrentUser(){
        
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            return}
        
            Firestore.firestore().collection("users").whereField("uid",isEqualTo: userUID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hud.dismiss()
                return
            } else {
                
                guard let dictionary = querySnapshot!.documents.first?.data() else { return }
                self.user = ActualUser(dictionary: dictionary)
                self.fetchUsersFromFirestore()
                }
        }
    }
    
    @objc func handleUserButton(){
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let shoeDetailsController = ShoeDetailsViewController()
//        shoeDetailsController.modalPresentationStyle = .fullScreen
        shoeDetailsController.cardViewModel = cardViewModel
        present(shoeDetailsController, animated: true)
    }
    
    
    
    //Mark :- Fileprivate
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore(){
        
        let minPrice = user?.minSeekingPrice ?? SettingsController.defaultMinSeekingPrice
        let maxPrice = user?.maxSeekingPrice ?? SettingsController.defaultMaxSeekingPrice
        
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
//        We will setup pagination on the following query:
        Firestore.firestore().collection("shoes").whereField("shoePrice", isGreaterThanOrEqualTo: minPrice).whereField("shoePrice", isLessThanOrEqualTo: maxPrice).getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err{
                print("Failed to load data from firebase:", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.setupCardFromUser(user: user)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                
            })
        }
    }
        
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls]) //z index follows the order of the previous array (priority of stacking)
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }

}
