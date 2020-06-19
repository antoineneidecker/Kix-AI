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

struct RecentMessage{
    let name, uid, price, brand : String
    let picUrl: [String]
    
    let timestamp : Timestamp
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["shoeName"] as? String ?? ""
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.picUrl = dictionary["picturesURL"] as? [String] ?? [""]
        self.price = dictionary["shoePrice"] as? String ?? ""
        
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        print(picUrl[0])
    }
}

class RecentMessageCell : LBTAListCell<RecentMessage>{
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "infoButton"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "SHOE HERE", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Some long line of text that should span 2 lines", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
        
    
    override func setupViews() {
        super.setupViews()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        userProfileImageView.layer.cornerRadius = 94 / 2
        
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
            messageTextLabel.text = item.price
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

class LikesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, Header>, UICollectionViewDelegateFlowLayout, CardViewDelegateMoreInfo{
    
    var delegate: CardViewDelegate?
    
    var customNavBar = LikedNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        fetchMatches()
        setupUI()
        
    }
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
        collectionView.verticalScrollIndicatorInsets.top = 150
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func fetchMatches(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        print("Here are my documents")
        
    Firestore.firestore().collection("swipes").document(currentUserId).collection("liked").whereField("liked", isEqualTo: 1).getDocuments{ (querySnapshot, err) in
        if let err = err {
            print("Failed to fetch liked shoes: ", err)
            return
        }
        print("Made it here!")

        querySnapshot?.documents.forEach({ (documentSnapshot) in
            let dictionary = documentSnapshot.data()
            self.items.append(.init(dictionary: dictionary))
        })
            
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return .init(width: view.frame.width, height: 0)
        }
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
    //        shoeDetailsController.modalPresentationStyle = .fullScreen
            shoeDetailsController.cardViewModel = cardViewModel
            present(shoeDetailsController, animated: true)
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentLike = self.items[indexPath.item]
        let dictionary = ["shoeName": recentLike.name, "shoeBrand": recentLike.brand, "shoePrice": recentLike.price, "picturesURL": recentLike.picUrl] as [String : Any]
        let user = User(dictionary: dictionary)
        let cardViewModel = user.toCardViewModel()
        didTapMoreInfo(cardViewModel: cardViewModel)
    }
    }
    
    

    



struct LikedShoe {

    
}

class shoeCell: LBTAListCell<LikedShoe> {

}

