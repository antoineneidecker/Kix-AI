//
//  ActualUser.swift
//  ShoeSwiperMenus
//
//  Created by Antoine Neidecker on 24/03/2020.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import UIKit


struct ActualUser {
    //defining our propreties for our model layer
    var firstName: String?
    var lastName: String?
    var email: String?
    var gender: String?
    var age: Int?
    var shoeSize: Int?
    var uid: String
    
    var minSeekingPrice: Int?
    var maxSeekingPrice: Int?
    
    init(dictionary: [String: Any]){
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 24
        self.gender = dictionary["gender"] as? String ?? ""
        self.shoeSize = dictionary["shoeSize"] as? Int ?? 42
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingPrice = dictionary["minSeekingPrice"] as? Int ?? 20
        self.maxSeekingPrice = dictionary["maxSeekingPrice"] as? Int ?? 200
    }
}





