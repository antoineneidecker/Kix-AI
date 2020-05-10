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
        bottomControls.colorButton.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)

        
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
    
    @objc fileprivate func handleColorChange(){
//        Make sure to change the topCardView to the new color shoe:
//        let cardView = topCardView
//        topCardView = nextCard
//        cardView?.removeFromSuperview()
    }
    
    fileprivate func setupCardFromShoe(shoe: Shoe) -> [CardView]{
    //        We must setup the SVMV here, and the list of cardViews, because we have to setup the linked list next.
    //        Iterate through the CardViewModels of the SVMV and setup their CardView
        let models = shoe.toCardViewModels()
        var cardViews = [CardView]()
        var counter = 0
        var previousColor: CardView?
        //        Set the first cardView of the list to the following:
        models.forEach { (cViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.delegate = self
            cardView.cardViewModel = cViewModel
            previousColor?.nextColor = cardView
            cardView.fillSuperview()
            if counter == 0{
                cardsDeckView.addSubview(cardView)
                cardsDeckView.sendSubviewToBack(cardView)
            }
            previousColor = cardView
            if counter == cardViews.count - 1{
                cardView.nextColor = cardViews[0]
            }
            cardViews.append(cardView)
            counter += 1
        }
//        returning an array of cardViews
        return cardViews
}
    
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
//        We must setup the SVMV here, and the list of cardViews, because we have to setup the linked list next.
//        Iterate through the CardViewModels of the SVMV and setup their CardView
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
//        Set the first cardView of the list to the following:
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
//        returning an array of cardViews
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
    
    //This is to fetch all the SHOES from firestore!!
    fileprivate func fetchUsersFromFirestore(){
        
        let minPrice = user?.minSeekingPrice ?? SettingsController.defaultMinSeekingPrice
        let maxPrice = user?.maxSeekingPrice ?? SettingsController.defaultMaxSeekingPrice
        
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
//        We will setup pagination on the following query:
        
        topCardView = nil
//         TO DO: SET FILTERS FOR PRICING!!!!
//        TOOK OFF FILTERS :/
        
        
        Firestore.firestore().collection("shoes").whereField("shoePrice", isGreaterThanOrEqualTo: minPrice).whereField("shoePrice", isLessThanOrEqualTo: maxPrice).getDocuments { (snapshot, err) in
            self.hud.dismiss()
            
            if let err = err{
                print("Failed to load data from firebase:", err)
                return
            }
            
            var previousCardView: CardView? //change this to [CardView?] when using the Shoe model
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let cardView = self.setupCardFromUser(user: user)
                
                previousCardView?.nextCardView = cardView
                previousCardView = cardView
                
                if self.topCardView == nil {
                    self.topCardView = cardView
                }

                
//                Here we can extract the data from FB and directly feed it to the SVMV. The SVMV will take care of the rest.
//                let shoeDictionary = documentSnapshot.data()
//                print(shoeDictionary)
//                The following line returns a Shoe object
//                let shoe = try! FirestoreDecoder().decode(Shoe.self, from: documentSnapshot.data())
//                let shoe = Shoe(dictionary: shoeDictionary as! [String : AnyHashable])
                
//                print("I AM HERE!!!")
//                print(shoe)
//                The following line returns an array of cardViews
//                let cardViews = self.setupCardFromShoe(shoe: shoe)
////                Iterate through the cardViews :
////                Make sure to set their nextCardView equal to the first of the next SVMV series. Done next:
//                if let previousCardView = previousCardView {
//                    previousCardView.forEach({ (card) in
//                        card.nextCardView = cardViews[0]
//                    })
//                }
//                previousCardView = cardViews
//
//
//
//                if self.topCardView == nil{
////                    Here the first of the first
//                    self.topCardView = cardViews[0]
//                }
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
        
        guard let cardUrl = topCardView?.cardViewModel?.imageUrls else {return}
        
        guard let brand = topCardView?.cardViewModel?.brand else {return}
        
        guard let price = topCardView?.cardViewModel?.price else {return}
                
        let documentData = ["shoeName": cardUID,
                            "shoePrice": price,
                            "shoeBrand": brand,
                            "liked" : didLike,
                            "picturesURL" : cardUrl,
                            "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument{ (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document: ", err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).collection("liked").document(cardUID).setData(documentData, merge: true)
                { (err) in
                    if let err = err{
                        print("Failed to updated swipe data: ", err)
                        return
                    }
                    print("Successfully updated swipe.")
                }
            }
            else{
                Firestore.firestore().collection("swipes").document(uid).collection("liked").document(cardUID).setData(documentData)
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
        
        let duration = 0.6
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
        let vc = LikesController()
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
