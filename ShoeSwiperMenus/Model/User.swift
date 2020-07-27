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
    var price: String?
    var brand: String?
    var imageNames: [String]
    
    
    init(dictionary: [String: Any]){
        var tempName = dictionary["shoeName"] as? String ?? ""
        let nsString = tempName as NSString
        let characterLimit = 16
        if nsString.length >= characterLimit
        {
            tempName = nsString.substring(with: NSRange(location: 0, length: nsString.length > characterLimit ? characterLimit : nsString.length))
            tempName = tempName + "..."
        }
        self.name = tempName
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        let tempPrice = dictionary["shoePrice"]! as? NSNumber ?? 99.90
        let newtempPrice = tempPrice.floatValue
//        print(tempPrice)
//        newtempPrice = Float(round(1000*newtempPrice)/1000)
//        self.price = String(newtempPrice)
        self.price = String(format: "%.2f", newtempPrice)
        self.imageNames = dictionary["picturesURL"] as? [String] ?? [""]
    }
    
    
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .heavy)])
        
        let priceString = price != nil ? "\("€" + price!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "  \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        let brandString = brand != nil ? "\(brand!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "\n\(brandString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
                
        return CardViewModel(name: self.name ?? "", brand: brandString, price: priceString, imageNames: imageNames, attributedString: attributedText, textAllignment: .left)
    }
}





