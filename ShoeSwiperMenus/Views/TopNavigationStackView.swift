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
    let fireButton = UIImageView(image: #imageLiteral(resourceName: "kix_logo_pink"))
    let messageButtons = UIButton(type: .system)
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        userButton.setImage(#imageLiteral(resourceName: "userProfile").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        messageButtons.setImage(#imageLiteral(resourceName: "wardrobe").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButtons.contentMode = .scaleAspectFit
        
        messageButtons.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        //This should be done with anchor but can't get the following line to work!!
//        messageButtons.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 8), size: .init(width: 38, height: 38))
        
        
        fireButton.contentMode = .scaleAspectFit
        
        [userButton,UIView(), fireButton,UIView(), messageButtons].forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .fillEqually
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
