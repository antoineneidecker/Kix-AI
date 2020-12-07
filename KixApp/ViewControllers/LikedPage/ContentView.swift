//
//  ContentView.swift
//  KixApp
//
//  Created by Ravi Shah on 01/12/20.
//  Copyright © 2020 Antoine Neidecker. All rights reserved.
//

import Foundation
import ASCollectionView

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel = PostViewModel()
    
    var postSections: ASTableViewSection<Int> {
        ASTableViewSection(id: 0, data: viewModel.posts) { post, _ in
            PostCell(post: post)
        }
    }
    
    var body: some View {
        ASTableView(section: postSections)
            .navigationBarTitle("")
            .navigationBarHidden(true)


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
