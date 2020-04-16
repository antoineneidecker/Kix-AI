//
//  User.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit


struct User: ProducesCardViewModel {
    //defining our propreties for our model layer
    var name: String?
    var price: Int?
    var brand: String?
    var imageNames: [String]
    
    
    init(dictionary: [String: Any]){
        self.name = dictionary["shoeName"] as? String ?? ""
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        self.price = dictionary["shoePrice"] as? Int ?? 99
        self.imageNames = dictionary["picturesURL"] as? [String] ?? [""]
    }
    
    
//    init?(dictionary: [String: Any]){
//        let mirrored_object = Mirror(reflecting: dictionary)
//        for (index, attr) in mirrored_object.children.enumerated() {
//            if let property_name = attr.label as String? {
//              print("Attr \(index): \(property_name) = \(attr.value)")
//            }
//        }
//    }
    
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let priceString = price != nil ? "\(price!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "  \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let brandString = brand != nil ? "\(brand!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "\n\(brandString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAllignment: .left)
    }
}





