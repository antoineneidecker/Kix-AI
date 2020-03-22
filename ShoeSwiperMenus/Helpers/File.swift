//
//  File.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 22/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialColorScheme


struct appColors {
    let colorScheme = MDCSemanticColorScheme()
    colorScheme.primaryColor = UIColor(red: CGFloat(0x21) / 255.0,
                                       green: CGFloat(0x21) / 255.0,
                                       blue: CGFloat(0x21) / 255.0,
                                       alpha: 1)
    colorScheme.primaryColorVariant = UIColor(red: CGFloat(0x44) / 255.0,
                                       green: CGFloat(0x44) / 255.0,
                                       blue: CGFloat(0x44) / 255.0,
                                       alpha: 1)

    // In this case we don't intend to use a secondary color, so we make it match our primary color
    colorScheme.secondaryColor = colorScheme.primaryColor

}
