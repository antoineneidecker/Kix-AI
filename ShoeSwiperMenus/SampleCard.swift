//
//  SampleCard.swift
//  
//
//  Created by Antoine Neidecker on 24/03/2020.
//

import Foundation
import Shuffle_iOS

class SampleCard: SwipeCard {
   override var swipeDirections {
      return [.left, .right]
   }
   
   init(image: UIImage) {
        content = UIImageView(image: image)
        leftOverlay = UIView()
        rightOverlay = UIView()
        
        leftOverlay.backgroundColor = .green
        rightOverlay.backgroundColor = .red
   }
}
