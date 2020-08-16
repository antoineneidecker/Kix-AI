////
////  Shoe.swift
////  ShoeSwiperMenus
////
////  Created by Antoine Neidecker on 20/04/2020.
////  Copyright © 2020 Antoine Neidecker. All rights reserved.
////
//
//import UIKit
//
//struct Shoe: ProduceCardViewModels, Codable {
//    
//    //defining our propreties for our model layer
//    
//    var name: String?
//    var price = [Int?]()
//    var brand: String?
//    var colors = [String?]()
//    var links = [[String]]()
//    var rating: String?
//    var amountOfRatings: String?
//    var ecoFriendly = [Bool?]()
//    var hotDrop = [Bool?]()
//    var outOfStock = [Bool?]()
//    var sale = [Int?]()
//    
//    
//    struct Base : Codable {
//        let shoeName: String
//        let shoeBrand: String
//        let picturesURL : [String]
//        let shoeAmountOfRating : String?
//        let shoeRating: String?
//        let shoeColor: String
//        let shoeEcoFriendly: Bool
//        let shoeHotDrop: Bool
//        let shoeLink: String
//        let shoeOutOfStock: Bool
//        let shoePrice: Int
//        let shoeSale: Int
////        let shoeDescription: Nested
//    }
//
////    struct Nested : Codable {
////
////
////    }
//    
//    init(dictionary: [String: Base]){
//        print("MADE IT HERE!!")
//        for (_,value) in dictionary {
//            self.name = value.shoeName
//            self.brand = value.shoeBrand
//            self.price.append(value.shoePrice)
//            self.colors.append(value.shoeColor)
//            self.links.append(value.picturesURL)
//            self.rating = value.shoeRating
//            self.amountOfRatings = value.shoeAmountOfRating
//            self.ecoFriendly.append(value.shoeEcoFriendly)
//            self.hotDrop.append(value.shoeHotDrop)
//            
//            
//        }
//        
//        
////        self.shoeModels = dictionary["picturesURL"] as? [String] ?? [""]
//    }
//    
////    func toCardViewModels() -> [CardViewModel] {
////        var counter = 0
////        var cardViewModelList = [CardViewModel]()
////        colors.forEach { (color) in
////            let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
////            let priceString = price[counter] != nil ? "\(price[counter]!)" : "N\\A"
////            attributedText.append(NSAttributedString(string: "  \(priceString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
////            let brandString = brand != nil ? "\(brand!)" : "N\\A"
////            attributedText.append(NSAttributedString(string: "\n\(brandString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
////            
////            let tempCardViewModel = CardViewModel(name: self.name ?? "", brand: brandString, price: priceString, imageNames: links[counter], attributedString: attributedText, textAllignment: .left)
////            cardViewModelList.append(tempCardViewModel)
////            counter += 1
////        }
////        return cardViewModelList
////    }
//}
//
