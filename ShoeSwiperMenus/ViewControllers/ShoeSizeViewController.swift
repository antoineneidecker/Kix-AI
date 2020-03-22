//
//  ShoeSizeViewController.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 19/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

class ShoeSizeViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    
    
    @IBOutlet weak var sizeShow: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
        setupElements()
    }
    
    func setupElements(){
        Utilities.styleTextField(sizeShow)
        sizeShow.isUserInteractionEnabled = false
        Utilities.styleFilledButton(nextButton)

    }
    
    @IBAction func changeSize(_ sender: UISlider) {
        slider.value = roundf(slider.value)
        let shoeSize = slider.value/2 + 38
        if Int(slider.value) % 2 == 0{
            sizeShow.text = String(Int(shoeSize))
        }
        else{
            sizeShow.text = String(shoeSize)
        }
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
