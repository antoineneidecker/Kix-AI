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
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageName = imageUrls[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    
    init(name: String, brand: String, price: String, imageNames: [String], attributedString: NSAttributedString, textAllignment: NSTextAlignment){
        self.name = name
        self.brand = brand
        self.price = price
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAllignment = textAllignment
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
