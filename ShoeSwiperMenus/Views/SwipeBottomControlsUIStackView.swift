//
//  SwipeBottomControlsUIStackView.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class SwipeBottomControlsUIStackView: UIStackView {
    
    
    static func createButton(image: UIImage) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal),for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
//    let refreshButton = createButton(image: #imageLiteral(resourceName: "undo"))
//    let dislikeButton = createButton(image: #imageLiteral(resourceName: "pass"))
//    let superLikeButton = createButton(image: #imageLiteral(resourceName: "star"))
//    let likeButton = createButton(image: #imageLiteral(resourceName: "heart"))
//    let colorButton = createButton(image: #imageLiteral(resourceName: "lightning"))

    
    let likeButton = createButton(image: #imageLiteral(resourceName: "LikeFluo"))
    let refreshButton = createButton(image: #imageLiteral(resourceName: "undo"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "DislikeFluo"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        // TODO:   Must reduce the size of the color change icon.
        [dislikeButton , refreshButton, likeButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
        
    }
    required init(coder: NSCoder) {
        fatalError("BottomSwipe not implemented")
    }
    

}
