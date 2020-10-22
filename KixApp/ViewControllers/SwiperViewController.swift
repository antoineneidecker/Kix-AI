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
import FirebaseFunctions
import InAppSettingsKit

class SwiperViewController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate, UITextViewDelegate {
    
    
    
    var panelTransitioningDelegate = PanelTransitioningDelegate()
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = SwipeBottomControlsUIStackView()
    
    var cardViewModels = [CardViewModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        navigationController?.navigationBar.isHidden = true
        
        topStackView.userButton.addTarget(self, action: #selector(handleUserButton), for: .touchUpInside)
        topStackView.messageButtons.addTarget(self, action: #selector(handleMessageButton), for: .touchUpInside)
        
//        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
//        bottomControls.colorButton.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)

        
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
            print("Oh shit..... no user id.")
            return}
        Firestore.firestore().collection("users").document(userUID).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hud.dismiss()
                return
            } else {
                guard let dictionary = querySnapshot!.data() else { return }
                self.user = ActualUser(dictionary: dictionary)
                self.fetchUsersFromFirestore()
                }
        }
    }
    
    @objc func handleUserButton(){
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
        
        let appSettingsViewController = NewSettingsViewController()
        appSettingsViewController.navigationController?.isNavigationBarHidden = false


        //        appSettingsViewController.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))]
//        appSettingsViewController.neverShowPrivacySettings = true
//        appSettingsViewController.showDoneButton = true
        
//        appSettingsViewController.isModalInPresentation = true
        navigationController!.pushViewController(appSettingsViewController, animated: true)

//        let settingsController = SettingsController()
//        settingsController.delegate = self
//        let navController = UINavigationController(rootViewController: settingsController)
//        navController.modalPresentationStyle = .fullScreen
//        self.present(navController, animated: true)
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
            })
            
        }
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    @objc fileprivate func handleRefresh(){
        if topCardView == nil {
            fetchUsersFromFirestore()
        }
    }
    
//    @objc fileprivate func handleColorChange(){
////        Make sure to change the topCardView to the new color shoe:
////        let cardView = topCardView
////        topCardView = nextCard
////        cardView?.removeFromSuperview()
//    }
    
//    fileprivate func setupCardFromShoe(shoe: Shoe) -> [CardView]{
//    //        We must setup the SVMV here, and the list of cardViews, because we have to setup the linked list next.
//    //        Iterate through the CardViewModels of the SVMV and setup their CardView
//        let models = shoe.toCardViewModels()
//        var cardViews = [CardView]()
//        var counter = 0
//        var previousColor: CardView?
//        //        Set the first cardView of the list to the following:
//        models.forEach { (cViewModel) in
//            let cardView = CardView(frame: .zero)
//            cardView.delegate = self
//            cardView.cardViewModel = cViewModel
//            previousColor?.nextColor = cardView
//            cardView.fillSuperview()
//            if counter == 0{
//                cardsDeckView.addSubview(cardView)
//                cardsDeckView.sendSubviewToBack(cardView)
//            }
//            previousColor = cardView
//            if counter == cardViews.count - 1{
//                cardView.nextColor = cardViews[0]
//            }
//            cardViews.append(cardView)
//            counter += 1
//        }
////        returning an array of cardViews
//        return cardViews
//}
    
    
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
        
        shoeDetailsController.transitioningDelegate = self.panelTransitioningDelegate
        shoeDetailsController.modalPresentationStyle = .custom
        shoeDetailsController.cardViewModel = cardViewModel
        shoeDetailsController.user = user
        present(shoeDetailsController, animated: true)
        
    }
    
    
    
    //Mark :- Fileprivate
    
    var lastFetchedUser: User?
    var previousCardView: CardView?
    
    //This is to fetch all the SHOES from firestore!!
    fileprivate func fetchUsersFromFirestore(){
//        print(Firebase.Auth.auth().currentUser?.uid)
        bottomControls.likeButton.isEnabled = false
        bottomControls.dislikeButton.isEnabled = false
        
        let minPrice = user?.minSeekingPrice ?? SettingsController.defaultMinSeekingPrice
        let maxPrice = user?.maxSeekingPrice ?? SettingsController.defaultMaxSeekingPrice
        
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
//        We will setup pagination on the following query:
        
        topCardView = nil
        
        Firestore.firestore().collection("shoes").whereField("shoePrice", isGreaterThanOrEqualTo: minPrice).whereField("shoePrice", isLessThanOrEqualTo: maxPrice).limit(to: 11).getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err{
                print("Failed to load data from firebase:", err)
                return
            }
            
//            var nextCardView: CardView?

            snapshot?.documents.forEach({ (documentSnapshot) in
                print(documentSnapshot.data())
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let cardView = self.setupCardFromUser(user: user)
                
                self.previousCardView?.nextCardView = cardView
                self.previousCardView = cardView
                
                if self.topCardView == nil {
                    self.topCardView = cardView
                }
            })
        }
        bottomControls.likeButton.isEnabled = true
        bottomControls.dislikeButton.isEnabled = true
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
        
        guard let shoeLink = topCardView?.cardViewModel.link else {return}
        
//        guard let eco = topCardView?.cardViewModel.ecoFriendly else {return}
//        
//        guard let hot = topCardView?.cardViewModel.hotDrop else {return}
        
        let shoeSize = user?.shoeSize
        
        guard let dictionary = topCardView?.cardViewModel.description else {return}
        
        guard let sizesAndPrices = topCardView?.cardViewModel.sizesAndPrices else {return}
        
        guard let sizesAndStock = topCardView?.cardViewModel.sizesAndStock else {return}
        
        guard let rating = topCardView?.cardViewModel.rating else {return}
        
        guard let amountOfRatings = topCardView?.cardViewModel.amountOfRatings else {return}
        
        guard let hotDrop = topCardView?.cardViewModel.hotDrop else {return}
        
        guard let ecoFriendly = topCardView?.cardViewModel.ecoFriendly else {return}
        
        guard let index = topCardView?.cardViewModel.index else {return}
        print(index)
        
        let digitPrice = price.split(separator: "€")
        let newdigitPrice = digitPrice[0]
        
        let numberPrice = Float(newdigitPrice)!
                
        let documentData = ["shoeName": cardUID,
                            "shoePrice": numberPrice,
                            "shoeBrand": brand,
                            "liked" : didLike,
                            "picturesURL" : cardUrl,
                            "shoeLink" : shoeLink,
                            "timestamp" : Timestamp(date: Date()),
                            "shoeSize" : shoeSize ?? -1,
                            "shoeRating" : rating,
                            "shoeAmountOfRating" : amountOfRatings,
                            "shoeHotDrop" : hotDrop,
                            "shoeEcoFriendly" : ecoFriendly,
                            "dictionary" : dictionary,
                            "sizesAndPrices": sizesAndPrices,
                            "sizesAndStock": sizesAndStock,
                            "index": index] as [String : Any]
        
        
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
                }
            }
        }
    }
    
    var swipeCounter = 1
    var batchCounter = 0
    var descent = GradientDescent.init(InitialVector: Matrix.random(rows: 1, columns: 40) * Matrix([100]))
    var goldenV = Matrix.random(rows: 1, columns: 40)
    
    fileprivate func handleGradientDescent(didLike : Bool, swipeW : Matrix) {
        let dW = descent.getdW(swipeW: swipeW)
        descent.AverageVector(newSwipedW: dW, liked: didLike)
        
        if (swipeCounter % 10) == 0 {
            goldenV = descent.AdamOp()
        }
        swipeCounter += 1
    }
    
    lazy var functions = Functions.functions()
    
    fileprivate func getBetterShoes(goldenV : Matrix){
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: view)
        
        let fireV = goldenV.array
//        guard let userUID = Auth.auth().currentUser?.uid else {
//        return}
        functions.httpsCallable("smartShoeFinder").call([
        "vector": fireV[0]]) { (result, error) in
          
            if let error = error as NSError? {
            print(error)
            if error.domain == FunctionsErrorDomain {
              let message = error.localizedDescription
                print("Fetch cloud function returned following error:")
                print(message)
            }
          }
            let array = result?.data as! [String: NSArray]
            var shoeCounter = 0
            let shoes = array["data"]! as NSArray
            for shoe in (shoes as! [NSDictionary]) {
                shoeCounter += 1
                print(shoeCounter)
                print(shoe["index"])
                let user = User(dictionary: shoe as! [String : Any])
                let cardView = self.setupCardFromUser(user: user)
                
                self.previousCardView?.nextCardView = cardView
                self.previousCardView = cardView

                if self.topCardView == nil {
                    self.topCardView = cardView
                }
            }
            self.hud.dismiss()
//            And if no more shoes match the 
            if (shoes.count == 0){
                let newhud = JGProgressHUD(style: .dark)
                newhud.indicatorView = nil
                newhud.textLabel.text = "You've seen all shoes"
                newhud.show(in: self.view)
                
            }
        }
    }
    
    @objc func handleLike(){
        handleGradientDescent(didLike: true, swipeW: topCardView?.cardViewModel.shoeVector ?? Matrix.random(rows: 1, columns: 40))
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 16)
//        print(topCardView?.cardViewModel.shoeVector)
        }

    @objc func handleDislike(){
        handleGradientDescent(didLike: false, swipeW: topCardView?.cardViewModel.shoeVector ?? Matrix.random(rows: 1, columns: 40))
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
        
        if topCardView == nil{
            
            getBetterShoes(goldenV: self.goldenV)
        }
    }
    
    @objc fileprivate func handleMessageButton(){
        let vc = LikesController()
        vc.actualUser = user
        navigationController?.pushViewController(vc, animated: true)
        print("Shoe Rack clicked!!!!")
    }
    let colors = Colors()
        
    fileprivate func setupLayout() {
        
        view.backgroundColor = .white
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer((backgroundLayer ?? nil)!, at: 0)
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls]) //z index follows the order of the previous array (priority of stacking)
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    
    }

}

class Colors {
    var gl:CAGradientLayer!
    

    init() {
        let colorTop = UIColor(red: 9.0 / 255.0, green: 13.0 / 255.0, blue: 75.0 / 255.0, alpha: 0.05).cgColor
        let colorBottom = UIColor(red: 0.0 / 255.0, green: 120 / 255.0, blue: 205.0 / 255.0, alpha: 0.2).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
