//
//  CardViewModel.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit


protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

protocol ProduceCardViewModels {
    func toCardViewModels() -> [CardViewModel]
}

class CardViewModel {
    //we'll define the propreties that our view will display/render out
    let name: String
    let brand: String
    let price: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAllignment: NSTextAlignment
    
    let amountOfRatings: String
    let rating: String
    let shoeColor: String
    let ecoFriendly: Bool
    let hotDrop: Bool
    let sale: Int
    let link: String
    
    let description: [String: String]
    let sizesAndPrices: [String: String]
    let sizesAndStock: [String: String]
    let shoeVector: Matrix
    
    let index: Int
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageName = imageUrls[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    
    init(name: String, brand: String, price: String, imageNames: [String], attributedString: NSAttributedString, textAllignment: NSTextAlignment, link: String, amountOfRatings: String, rating: String, shoeColor : String, ecoFriendly: Bool, hotDrop: Bool, sale: Int, description: [String: String], sizesAndPrices: [String: String], sizesAndStock: [String: String], shoeVector: Matrix, index: Int){
        self.name = name
        self.brand = brand
        self.price = price
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAllignment = textAllignment
        
        self.link = link
        self.amountOfRatings = amountOfRatings
        self.rating = rating
        self.shoeColor = shoeColor
        self.ecoFriendly = ecoFriendly
        self.hotDrop = hotDrop
        self.sale = sale
        
        self.description = description
        self.sizesAndPrices = sizesAndPrices
        self.sizesAndStock = sizesAndStock
        self.shoeVector = shoeVector
        self.index = index
    }
    
    //Reactive programming
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    
    func advanceToNextPhoto(){
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(0, imageIndex - 1)
    }
    
}


//what do we do with this card view model thing?
