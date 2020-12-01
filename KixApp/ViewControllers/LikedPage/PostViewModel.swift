//
//  PostViewModel.swift
//  InstagramFeed
//
//  Created by Ravi Shah on 2/27/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [PostFeed]()
    
    init() {
        let post1 = PostFeed(id: 0, username: "shoes", caption: "Test Caption",
                             imageName: ["shoes1","shoes2","shoes3"], location: "Miami")
        
        let post2 = PostFeed(id: 1, username: "nike", caption: "Test Caption 2",
                             imageName: ["shoes2","shoes3","shoes4"], location: "Miami")
        
        posts.append(post1)
        posts.append(post2)
    }
}
