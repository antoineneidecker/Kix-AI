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
}


class LikedNavBar: UIView {
    
    var delegate: likedControllerHeaderDelegate?
    var isRackViewMeta = true
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "kix_logo_pink"), tintColor: .lightGray)
    
    var rackButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rack", for: .normal)
        button.addTarget(self, action: #selector(handleChangeRackView), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        
//        button.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        return button
    }()
    
    var feedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Feed", for: .normal)
        button.addTarget(self, action: #selector(handleChangeFeedView), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
//        button.tintColor = UIColor(white: 0, alpha: 0.2 )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "wardrobe").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
       iconImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       
       setupShadow(opacity: 0.4, radius: 8, offset: .init(width: 0, height: 7), color: .init(white: 0, alpha: 0.3))
       
       stack(iconImageView.withHeight(55),hstack(rackButton,feedButton, distribution: .fillEqually)).padTop(10)
        
        if isRackViewMeta{
            rackButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            feedButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        }
        else{
            feedButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            rackButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        }
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))

    }
    
    @objc func handleChangeRackView(){
        rackButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        feedButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        delegate?.didChangeToRackView()
        return
    }
    
    @objc func handleChangeFeedView(){
        feedButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        rackButton.tintColor = UIColor(white: 0, alpha: 0.2 )
        
        delegate?.didChangeToFeedView()
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
        
    }
}
