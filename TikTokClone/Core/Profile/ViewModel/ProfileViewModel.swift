//
//  ProfileViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import AVFoundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetchPosts() async {
        self.posts = DeveloperPreview.posts.filter({ $0.ownerUid == user.username })
    }    
}
