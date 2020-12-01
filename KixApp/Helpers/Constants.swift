//
//  Constants.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-23.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        
    }
    
    
}

struct INSTAGRAM_IDS {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "REPLACE_YOUR_CLIENT_ID_HERE"
    
    static let INSTAGRAM_CLIENTSERCRET = "REPLACE_YOUR_CLIENT_SECRET_HERE"
    
    static let INSTAGRAM_REDIRECT_URI = "REPLACE_YOUR_REDIRECT_URI_HERE"
    
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    
}
