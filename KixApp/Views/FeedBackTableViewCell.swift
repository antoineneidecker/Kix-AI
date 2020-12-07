//
//  FeedBackTableViewCell.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 15/06/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//
import UIKit
import LGButton

protocol FeedbackDelegate {
    func didTapFeedback()
}

class FeedBackTableViewCell: UITableViewCell {
    
    var feedbackDelegate: FeedbackDelegate!
    
    @objc fileprivate func handleFeedBack(){
        feedbackDelegate.didTapFeedback()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let logoutStyle: LGButton = {
            let button = LGButton()
            button.titleString = "What do you think?"
            button.fullyRoundedCorners = true
            button.titleFontSize = 20
            button.bgColor = #colorLiteral(red: 0.3450980392, green: 0.8862745098, blue: 0.4549019608, alpha: 1)
            button.addTarget(self, action: #selector(handleFeedBack), for: .touchUpInside)
            return button
        }()
        
//        let logoutButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("Let us know what you think", for: .normal)
//            button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//            button.layer.borderWidth = 2
//            button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
//            button.layer.cornerRadius = 22
//            button.tintColor = UIColor.black
//            button.heightAnchor.constraint(equalToConstant: 55).isActive = true
//            button.addTarget(self, action: #selector(handleFeedBack), for: .touchUpInside)
//        return button
//        }()
        
        let overAllStackView = UIStackView(arrangedSubviews:[logoutStyle])
        overAllStackView.spacing = 16
        self.contentView.addSubview(overAllStackView)
        overAllStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
