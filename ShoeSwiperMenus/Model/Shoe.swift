//
//  Shoe.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 20/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

struct Shoe: ProduceShoeModel {
    //defining our propreties for our model layer
    
    var name: String?
    var price: Int?
    var brand: String?
    var shoeModels: [String: AnyObject] = [String: AnyObject]()
    
    
    init(dictionary: [String: Any]){
        self.name = dictionary["shoeName"] as? String ?? ""
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        self.price = dictionary["shoePrice"] as? Int ?? 99
//        self.shoeModels = dictionary["picturesURL"] as? [String] ?? [""]
    }

    
    func toShoeModelViewModel() -> ShoeModelViewModel{
        
//        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
//
//        let priceString = price != nil ? "\(price!)" : "N\\A"
//
//        attributedText.append(NSAttributedString(string: "  \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
//
//        let brandString = brand != nil ? "\(brand!)" : "N\\A"
//        attributedText.append(NSAttributedString(string: "\n\(brandString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
//
//        return CardViewModel(name: self.name ?? "", imageNames: imageNames, attributedString: attributedText, textAllignment: .left)
        return ShoeModelViewModel(shoeName: "", currentShoe: CardViewModel(name:  "", imageNames: [""], attributedString: NSMutableAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)]), textAllignment: .left))
    }
}

