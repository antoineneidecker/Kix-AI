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


class FeedViewController: LBTAListHeaderController<RecentMessageCell, RecentMessage, Header>, UICollectionViewDelegateFlowLayout, CardViewDelegateMoreInfo, likedControllerHeaderDelegate{
    
    func didChangeToRackView() {
        isRackViewMeta = 0

        let controller = LikesController()
        navigationController?.replaceTopViewController(with: controller, animated: false)
    }
    
    func didChangeToFavortiesView() {
        isRackViewMeta = 1
        let controller = FavoritesController()
        navigationController?.replaceTopViewController(with: controller, animated: false)

    }
    
    func didChangeToFeedView() {
        isRackViewMeta = 2
//        let storyBoardd =  UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyBoardd.instantiateViewController(withIdentifier: "FeedController") as! FeedController
//        navigationController?.replaceTopViewController(with: controller, animated: false)

    }
    
    
    
    
    var actualUser : ActualUser?
    
    var panelTransitioningDelegate = PanelTransitioningDelegate()
    
    var listener: ListenerRegistration?
    
    var delegate: CardViewDelegate?
    
    var customNavBar = LikedNavBar()
    
    let homePostCellId = "homePostCellId"
    
    var recentMessageDictionary = [String: RecentMessage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMatches()
        setupUI()
    }
    
    fileprivate func setupUI() {

        customNavBar.delegate = self

        collectionView.backgroundColor = .white

        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 110))
        collectionView.contentInset.top = 110
        collectionView.verticalScrollIndicatorInsets.top = 110

        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
        let childView = UIHostingController(rootView: ContentView())
        childView.view.backgroundColor = .white
        childView.navigationController?.isNavigationBarHidden = true
        childView.navigationController?.setNavigationBarHidden(true, animated: false)
                addChild(childView)
        childView.view.frame = CGRect(x: 0, y: 164, width: self.view.bounds.width, height: self.view.bounds.height - 164)
        self.view.addSubview(childView.view)
                childView.didMove(toParent: self)
    }
    
    
    
    fileprivate func fetchMatches(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("users").document(currentUserId).collection("favorites")
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
                
        shoeDetailsController.transitioningDelegate                = self.panelTransitioningDelegate
        shoeDetailsController.modalPresentationStyle                = .custom
        shoeDetailsController.cardViewModel = cardViewModel
        shoeDetailsController.user = actualUser
        
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
    
import ASCollectionView
import SwiftUI

extension UINavigationController {
  func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
    var vcs = viewControllers
    vcs[vcs.count - 1] = viewController
    setViewControllers(vcs, animated: animated)
  }
}
