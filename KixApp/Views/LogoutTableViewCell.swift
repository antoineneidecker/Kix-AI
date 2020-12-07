//
//  LogoutTableViewCell.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 14/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import Firebase
import LGButton

protocol LogoutDelegate {
    func didTapLogout()
}

class LogoutTableViewCell: UITableViewCell {

    var logoutDelegate: LogoutDelegate!
     
    
    @objc fileprivate func handleLogout(){
        logoutDelegate.didTapLogout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let logoutStyle: LGButton = {
            let button = LGButton()
            button.isUserInteractionEnabled = true
            button.titleString = "Logout"
            button.fullyRoundedCorners = true
            button.titleFontSize = 20
            button.titleColor = #colorLiteral(red: 0.8392156863, green: 0.2274509804, blue: 0, alpha: 1)
            button.borderColor = #colorLiteral(red: 0.8392156863, green: 0.2274509804, blue: 0, alpha: 1)
            button.borderWidth = 2
            button.bgColor = .clear
            button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            return button
        }()
        
//        let logoutButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("Log Out", for: .normal)
//            button.setTitleColor(#colorLiteral(red: 0.7137254902, green: 0.09411764706, blue: 0.1529411765, alpha: 1), for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//            button.layer.borderWidth = 2
//            button.layer.borderColor = #colorLiteral(red: 0.7137254902, green: 0.09411764706, blue: 0.1529411765, alpha: 1)
//            button.layer.cornerRadius = 22
//            button.tintColor = UIColor.black
//            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
//            button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
//        return button
//        }()
        
        let overAllStackView = UIStackView(arrangedSubviews:[logoutStyle])
        overAllStackView.spacing = 16
        self.contentView.addSubview(overAllStackView)
       // addSubview(overAllStackView)
        overAllStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
