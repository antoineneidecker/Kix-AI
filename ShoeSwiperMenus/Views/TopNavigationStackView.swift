//
//  TopNavigationStackView.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let userButton = UIButton(type: .system)
    let fireButton = UIImageView(image: #imageLiteral(resourceName: "fireIconTop"))
    let messageButtons = UIButton(type: .system)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        userButton.setImage(#imageLiteral(resourceName: "userProfile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButtons.setImage(#imageLiteral(resourceName: "chatIconTop").withRenderingMode(.alwaysOriginal), for: .normal)
        fireButton.contentMode = .scaleAspectFit
        
        [userButton,UIView(), fireButton,UIView(), messageButtons].forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
