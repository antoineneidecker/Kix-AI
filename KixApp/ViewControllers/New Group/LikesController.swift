//
//  LikesController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 17/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import LBTATools
import Firebase
import JGProgressHUD


struct RecentMessage{
    let name, uid, brand, link, rating, amountOfRatings : String
    let price : Float
    let picUrl: [String]
    let eco, hot: Bool
    let sizesAndPrices : [String : String]
    let sizesAndStock : [String : String]
    
    
    
    let timestamp : Timestamp
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["shoeName"] as? String ?? ""
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.picUrl = dictionary["picturesURL"] as? [String] ?? [""]
        self.price = dictionary["shoePrice"] as? Float ?? 50.00
        self.link = dictionary["shoeLink"] as? String ?? ""
        self.eco = dictionary["shoeEcoFriendly"] as? Bool ?? false
        self.hot = dictionary["shoeHotDrop"] as? Bool ?? false
        self.rating = dictionary["shoeRating"] as? String ?? ""
        self.amountOfRatings = dictionary["shoeAmountOfRating"] as? String ?? ""
        self.sizesAndPrices = dictionary["sizesAndPrices"] as? [String : String] ?? ["" : ""]
        self.sizesAndStock = dictionary["sizesAndStock"] as? [String : String] ?? ["" : ""]
        
        
        
        
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class RecentMessageCell : LBTAListCell<RecentMessage>{
     
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "infoButton"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "SHOE HERE", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Some long line of text that should span 2 lines", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
        
    


    
    override func setupViews() {
        super.setupViews()
        
        userProfileImageView.layer.cornerRadius = 94 / 2
        
        
        //    DELETE
//        hstack(textView, sendButton.withSize(.init(width: 60, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        //    DELETE

        
        hstack(userProfileImageView.withWidth(94).withHeight(94),
               stack(usernameLabel, messageTextLabel, spacing: 2),
               spacing: 20,
               alignment: .center
        ).padLeft(20).padRight(20)
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
    
    
    override var item: RecentMessage!{
        didSet{
            usernameLabel.text = item.name
            messageTextLabel.text = "€" + String(item.price)
            userProfileImageView.sd_setImage(with: URL(string: item.picUrl[0]))
        }
    }
}




class Header: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class LikesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, Header>, UICollectionViewDelegateFlowLayout, CardViewDelegateMoreInfo, likedControllerHeaderDelegate{

    
    
    func didChangeToRackView() {
        isRackViewMeta = 0

        collectionView.reloadData()
    }
    
    func didChangeToFavortiesView() {
        isRackViewMeta = 1
        let controller = FavoritesController()
        navigationController?.replaceTopViewController(with: controller, animated: false)
    }
    
    func didChangeToFeedView() {

//        isRackViewMeta = 2
//        let storyBoardd =  UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyBoardd.instantiateViewController(withIdentifier: "FeedController") as! FeedController
//        navigationController?.replaceTopViewController(with: controller, animated: false)
        isRackViewMeta = 2
        let controller  = FeedViewController()

        navigationController?.replaceTopViewController(with: controller, animated: false)

    }

    
    var actualUser : ActualUser?
    
    var panelTransitioningDelegate = PanelTransitioningDelegate()
    
    var listener: ListenerRegistration?
    
    var delegate: CardViewDelegate?
    
    var customNavBar = LikedNavBar()
    
    let homePostCellId = "homePostCellId"
    
    
    
    var recentMessageDictionary = [String: RecentMessage]()
    

//    The collection view background color does not change when going back and forth between tabs.
//    This means that the collection view is not changing.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        fetchMatches()
        setupUI()
    }
    
    fileprivate func setupUI() {
        customNavBar.delegate = self
        

        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 110))
//        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 110
        collectionView.verticalScrollIndicatorInsets.top = 110
                
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    
    fileprivate func fetchMatches(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("swipes").document(currentUserId).collection("liked").whereField("liked", isEqualTo: 1)
        listener = query.addSnapshotListener { (snapshot, err) in

            if let err = err {
                print("Failed to fetch liked shoes: ", err)
                return
            }
            
            snapshot?.documents.forEach({ (change) in
                let dictionary = change.data()
                let recentMessage = RecentMessage(dictionary: dictionary)
                let uid = recentMessage.brand + recentMessage.name
                self.recentMessageDictionary[uid] = recentMessage
            })
            self.resetItems()
            
            }
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                return .init(width: view.frame.width, height: 0)
            }
    }
    fileprivate func resetItems(){
        let values = Array(recentMessageDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        
        collectionView.reloadData()
    }
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 140)

    }
    
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let shoeDetailsController = ShoeDetailsViewController()
                
        shoeDetailsController.transitioningDelegate = self.panelTransitioningDelegate
        shoeDetailsController.modalPresentationStyle = .custom
        shoeDetailsController.user = actualUser
        shoeDetailsController.cardViewModel = cardViewModel
        
        
        present(shoeDetailsController, animated: true)
        
        
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let recentLike = self.items[indexPath.item]
        //        The following dictionary initionalizes a User object. Therefore the dic elements must match the User dic elements.
                let dictionary = ["shoeName": recentLike.name, "shoeBrand": recentLike.brand, "shoePrice": recentLike.price, "shoeLink": recentLike.link,"shoeEcoFriendly": recentLike.eco, "shoeHotDrop": recentLike.hot, "picturesURL": recentLike.picUrl, "shoeRating": recentLike.rating, "shoeAmountOfRating": recentLike.amountOfRatings, "sizesAndPrices": recentLike.sizesAndPrices, "sizesAndStock": recentLike.sizesAndStock] as [String : Any]
                let user = User(dictionary: dictionary)
                let cardViewModel = user.toCardViewModel()
                didTapMoreInfo(cardViewModel: cardViewModel)
        }
    }
    
