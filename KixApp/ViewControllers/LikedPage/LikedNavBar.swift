//
//  LikedNavBar.swift
//  KixApp
//
//  Created by Antoine Neidecker on 07/05/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import LBTATools
import UIKit


protocol likedControllerHeaderDelegate {
    func didChangeToRackView()
    func didChangeToFeedView()
    func didChangeToFavortiesView()
}

var isRackViewMeta = 0

class LikedNavBar: UIView {
    
    var delegate: likedControllerHeaderDelegate?
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "kix_logo_pink"), tintColor: .lightGray)
    
    var rackTab : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rack", for: .normal)
        button.addTarget(self, action: #selector(handleChangeRackView), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        return button
    }()
    
    
    var favoriteTab : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Favorites", for: .normal)
            button.addTarget(self, action: #selector(handleChangeFavoritesView), for: .touchUpInside)
            button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
            return button
        }()
    
    var feedTab : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Feed", for: .normal)
        button.addTarget(self, action: #selector(handleChangeFeedView), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "wardrobe").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
       iconImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       
       setupShadow(opacity: 0.4, radius: 8, offset: .init(width: 0, height: 7), color: .init(white: 0, alpha: 0.3))
       
        stack(iconImageView.withHeight(55),hstack(rackTab,favoriteTab, feedTab, distribution: .fillEqually)).padTop(10)
        
        if isRackViewMeta == 0{
            rackTab.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            favoriteTab.tintColor = UIColor(white: 0, alpha: 0.2 )
            feedTab.tintColor = UIColor(white: 0, alpha: 0.2 )
        }
        else if isRackViewMeta == 1{
            rackTab.tintColor = UIColor(white: 0, alpha: 0.2 )
            favoriteTab.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            feedTab.tintColor = UIColor(white: 0, alpha: 0.2 )

        }
        else{
            rackTab.tintColor = UIColor(white: 0, alpha: 0.2 )
            favoriteTab.tintColor = UIColor(white: 0, alpha: 0.2 )
            feedTab.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)

        }
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
    
    @objc func handleChangeRackView(){
//        rackButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
//        feedButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        delegate?.didChangeToRackView()
        return
    }
    
    @objc func handleChangeFeedView(){
//        feedButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
//        rackButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        
        delegate?.didChangeToFeedView()
        return
    }
    
    @objc func handleChangeFavoritesView(){
//        feedButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
//        rackButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        
        delegate?.didChangeToFavortiesView()
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
        
    }
}
