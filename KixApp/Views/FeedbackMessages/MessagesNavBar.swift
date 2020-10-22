//
//  MessagesNavBar.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 17/06/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import LBTATools
import UIKit

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 65, image: #imageLiteral(resourceName: "kix_logo_pink copy"))
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9792197347, green: 0.2754820287, blue: 0.3579338193, alpha: 1))
        
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                spacing: 0,
                alignment: .center),
            alignment: .center
        ).withMargins(.init(top: 0, left: 0, bottom: 0, right: 50))
        
        hstack(backButton.withWidth(50),
               middleStack).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

