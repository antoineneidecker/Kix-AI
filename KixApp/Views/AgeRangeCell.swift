//
//  AgeRangeCell.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 13/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 20
        slider.maximumValue = 300
        return slider
    }()
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min Price"
        return label
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 20
        slider.maximumValue = 300
        return slider
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max Price"
        return label
    }()
    
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // vertical stack view of sliders
        let overAllStackView = UIStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [minLabel,minSlider]),UIStackView(arrangedSubviews: [maxLabel,maxSlider])])
        overAllStackView.axis = .vertical
        overAllStackView.spacing = 16
        self.contentView.isUserInteractionEnabled = false
        self.addSubview(overAllStackView)
        overAllStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
