//
//  ShoeTypeViewController.swift
//  KixApp
//
//  Created by Antoine Neidecker on 21/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class ShoeTypeViewController: UIViewController {

    @IBOutlet weak var button1: MDCButton!

    @IBOutlet weak var button2: MDCButton!

    @IBOutlet weak var button3: MDCButton!

    @IBOutlet weak var button4: MDCButton!

    @IBOutlet weak var button5: MDCButton!

    @IBOutlet weak var button6: MDCButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

//    func globalContainerScheme() -> MDCContainerScheming {
//      let containerScheme = MDCContainerScheme()
//      // Customize containerScheme here...
//      return containerScheme
//    }

    func setupElements(){

//        let colorScheme = MDCSemanticColorScheme()
//        colorScheme.primaryColor = UIColor(red: CGFloat(0x21) / 255.0,
//                                           green: CGFloat(0x21) / 255.0,
//                                           blue: CGFloat(0x21) / 255.0,
//                                           alpha: 1)
//        colorScheme.primaryColorVariant = UIColor(red: CGFloat(0x44) / 255.0,
//                                           green: CGFloat(0x44) / 255.0,
//                                           blue: CGFloat(0x44) / 255.0,
//                                           alpha: 1)
//
//        // In this case we don't intend to use a secondary color, so we make it match our primary color
//        colorScheme.secondaryColor = colorScheme.primaryColor
//
//        let containerScheme = globalContainerScheme()
//
//        button1.applyTextTheme(withScheme: containerScheme)
//        let containerScheme = MDCContainerScheme()
//
//        containerScheme.shapeScheme = shapeScheme
//
//        button1.applyContainedTheme(withScheme: containerScheme)
//        button1.applyTextTheme(withScheme: containerScheme)
//        button1.applyOutlinedTheme(withScheme: containerScheme)
    }

}
