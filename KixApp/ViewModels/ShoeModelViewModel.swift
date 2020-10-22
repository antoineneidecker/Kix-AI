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

    let cardViewModels: [CardViewModel]
    
    init(cardViewModels: [CardViewModel]){
        self.cardViewModels = cardViewModels
    }
}

