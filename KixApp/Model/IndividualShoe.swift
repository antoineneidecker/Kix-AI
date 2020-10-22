//
//  IndividualShoe.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 07/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//


import UIKit


struct IndividualShoe {
    //defining our propreties for our model layer
    let name: String
    let price: Int
    let brand: String
    let imageNames: [String]
    
    init(dictionary: [String: Any]){
        let name = dictionary["shoeName"] as? String ?? ""
        self.name = name
        let price = dictionary["shoePrice"] as? Int ?? 0
        self.price = price
        let brand = dictionary["shoeBrand"] as? String ?? ""
        self.brand = brand
//        The following might be wrong because our imageNames is already an array.
        let imageNames = dictionary["picturesURL"] as? String ?? ""
        self.imageNames = [imageNames]
    }
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  $\(price)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(brand)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedText: attributedText, textAllignment: .left)
    }
}
