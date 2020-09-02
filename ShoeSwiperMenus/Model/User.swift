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
    
    var amountOfRatings: String?
    var rating: String?
    var shoeColor: String?
    var ecoFriendly: Bool?
    var hotDrop: Bool?
    var sale: Int?
    var link: String?
    
    var description: [String: String]?
    var sizesAndPrices: [String : String]?
    var sizesAndStock: [String : String]?
    
    var shoeVector: Matrix
    
    
    init(dictionary: [String: Any]){
        var tempName = dictionary["shoeName"] as? String ?? ""
        
        let nsString = tempName as NSString
        let characterLimit = 32
        if nsString.length >= characterLimit
        {
            tempName = nsString.substring(with: NSRange(location: 0, length: nsString.length > characterLimit ? characterLimit : nsString.length))
            tempName = tempName + "..."
        }
        
        self.name = tempName
        self.brand = dictionary["shoeBrand"] as? String ?? ""
        let tempPrice = dictionary["shoePrice"]! as? NSNumber ?? 99.90
        let newtempPrice = tempPrice.floatValue
        self.price = String(format: "%.2f", newtempPrice)
        self.imageNames = dictionary["picturesURL"] as? [String] ?? [""]
        
        self.link = dictionary["shoeLink"] as? String ?? ""
        self.amountOfRatings = dictionary["shoeAmountOfRating"] as? String ?? ""
        self.rating = dictionary["shoeRating"] as? String ?? ""
        self.shoeColor = dictionary["shoeColor"] as? String ?? ""
        self.ecoFriendly = dictionary["shoeEcoFriendly"] as? Bool ?? false
        self.hotDrop = dictionary["shoeHotDrop"] as? Bool ?? false
        self.sale = dictionary["shoeSale"] as? Int ?? 0
        
        self.description = dictionary["shoeDescription"] as? [String : String] ?? ["" : ""]
        self.sizesAndPrices = dictionary["sizesAndPrices"] as? [String : String] ?? ["" : ""]
        self.sizesAndStock = dictionary["sizesAndStock"] as? [String : String] ?? ["" : ""]
        
        let shoeVectorDouble = dictionary["shoeVector"] as? [Double] ?? [2.2,2.2]
        
        self.shoeVector = Matrix(shoeVectorDouble)
        
    }
    
    
    func toCardViewModel() -> CardViewModel{
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .heavy)])

        let priceString = price != nil ? "\("€" + price!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "  \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        let brandString = brand != nil ? "\(brand!)" : "N\\A"
        
        attributedText.append(NSAttributedString(string: "\n\(brandString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        let shoeLink = link != nil ? "\(link!)" : "N\\A"
        
        let shoeAmountRating = amountOfRatings != nil ? "\(amountOfRatings!)" : "N\\A"
        
        let shoeRating = rating != nil ? "\(rating!)" : "N\\A"
        
        let color = shoeColor != nil ? "\(shoeColor!)" : "N\\A"
        
        let ecoString = ecoFriendly != nil ? ecoFriendly! : false

        let shoeHotDrop = hotDrop != nil ? hotDrop! : false
        
        let shoeSale = sale != nil ? sale! : 0
        
        let shoeDescription = description != nil ? description! : ["" : ""]
        let shoeSizesAndPrices = sizesAndPrices != nil ? sizesAndPrices! : ["" : ""]
        let shoeSizesAndStock = sizesAndStock != nil ? sizesAndStock! : ["" : ""]
        
        let vector = shoeVector
                
        return CardViewModel(name: self.name ?? "", brand: brandString, price: priceString, imageNames: imageNames, attributedString: attributedText, textAllignment: .left, link: shoeLink,  amountOfRatings: shoeAmountRating, rating: shoeRating, shoeColor: color, ecoFriendly: ecoString, hotDrop: shoeHotDrop, sale: shoeSale, description: shoeDescription, sizesAndPrices: shoeSizesAndPrices, sizesAndStock: shoeSizesAndStock, shoeVector: vector)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}





