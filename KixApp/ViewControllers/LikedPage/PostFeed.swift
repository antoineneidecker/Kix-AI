//
//  Post.swift
//  InstagramFeed
//
//  Created by Stephen Dowless on 2/27/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Foundation

struct PostFeed: Identifiable {
    let id: Int
    let username: String
    let caption: String
    let imageName: [String]
    let location: String
}
