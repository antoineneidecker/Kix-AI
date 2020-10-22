//
//  NewSettingsViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 02/09/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit
import InAppSettingsKit

class NewSettingsViewController: IASKAppSettingsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showDoneButton = true
        self.neverShowPrivacySettings = true
        

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
