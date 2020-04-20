//
//  ShoeModelViewModel.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 20/04/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit

protocol ProduceShoeModel{
    func toShoeModelViewModel() -> ShoeModelViewModel
}

class ShoeModelViewModel {
    let shoeName: String
    let currentShoe: CardViewModel
    
    fileprivate var shoeModelIndex = 0 {
        didSet{
//            let imageName = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
//            imageIndexObserver?(imageIndex, image)
        }
    }
    
    init(shoeName: String, currentShoe: CardViewModel){
        self.shoeName = shoeName
        self.currentShoe = currentShoe
        
    }
    
    var shoeImageIndexObserver: ((Int, UIImage?) -> ())?
    
    
    func advanceToNextShoeModel(){
        shoeModelIndex = (shoeModelIndex + 1 % imageUrls.count - 1)
    }
    
}

