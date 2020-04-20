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
        
        navigationController?.navigationBar.isHidden = true
        
        topStackView.userButton.addTarget(self, action: #selector(handleUserButton), for: .touchUpInside)
        topStackView.messageButtons.addTarget(self, action: #selector(handleMessageButton), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)

        
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
        if topCardView == nil {
            fetchUsersFromFirestore()
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
        
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
        
        topCardView = nil
        Firestore.firestore().collection("shoes").whereField("shoePrice", isGreaterThanOrEqualTo: minPrice).whereField("shoePrice", isLessThanOrEqualTo: maxPrice).getDocuments { (snapshot, err) in
            self.hud.dismiss()
            
            if let err = err{
                print("Failed to load data from firebase:", err)
                return
            }
            
//            We are going to setup the nextCardView relationship for all cards somehow:
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let cardView = self.setupCardFromUser(user: user)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                previousCardView?.nextCardView = cardView
                previousCardView = cardView
//                Use this nextCardView == nil to load the pictures!!
                
                if self.topCardView == nil{
                    self.topCardView = cardView
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
        
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let cardUID = topCardView?.cardViewModel?.name else {return}
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument{ (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document: ", err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData)
                { (err) in
                    if let err = err{
                        print("Failed to updated swipe data: ", err)
                        return
                    }
                    print("Successfully updated swipe.")
                }
            }
            else{
                Firestore.firestore().collection("swipes").document(uid).setData(documentData)
                { (err) in
                    if let err = err{
                        print("Failed to save swipe data: ", err)
                        return
                    }
                    print("Successfully saved swipe.")
                }
            }
        }
    }
    
    @objc func handleLike(){
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 16)
    }

    @objc func handleDislike(){
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -16)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        
        let duration = 0.8
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    @objc fileprivate func handleMessageButton(){
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .fullScreen
//        self.present(navController, animated: true)
    
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
