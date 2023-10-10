//
//  FeedCellViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    func like() async {
        self.post.didLike = true
        self.post.likes += 1

    }
    
    func unlike() async {
        self.post.didLike = false
        self.post.likes -= 1
    }
    
    func save() async {
        post.didSave = true
        post.saveCount += 1
    }
    
    func unsave() async {
        post.didSave = false
        post.saveCount -= 1
    }
}
