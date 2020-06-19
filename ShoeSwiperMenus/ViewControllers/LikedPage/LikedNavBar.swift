//
//  LikedNavBar.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 07/05/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import LBTATools
import UIKit



class LikedNavBar: UIView {
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "kix_logo_pink"), tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "wardrobe").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
       iconImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       
       let wardrobeLabel = UILabel(text: "Shoe Rack", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), textAlignment: .center)
       
       let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), textAlignment: .center)
       
       setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
       
       stack(iconImageView.withHeight(55),hstack(wardrobeLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
        
    }
}
