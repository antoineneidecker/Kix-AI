//
//  SettingsCell.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 11/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    class SettingsTextField: UITextField{
        override var intrinsicContentSize: CGSize{
            return .init(width: 0, height: 44)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
    }
    
    let textField: UITextField = {
        let tf = SettingsTextField()
        tf.autocorrectionType = .no
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
