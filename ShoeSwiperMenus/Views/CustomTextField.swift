//
//  CustomTextField.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 25/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    
    init(padding: CGFloat){
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 50)
    }
}
