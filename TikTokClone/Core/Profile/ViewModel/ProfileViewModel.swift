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
    
    private let userService: UserService
    private var didCompleteFollowCheck = false
    
    init(user: User, userService: UserService) {
        self.user = user
        self.userService = userService
    }
    
    func fetchPosts() async {
        self.posts = DeveloperPreview.posts.filter({ $0.ownerUid == user.username })
    }    
}

// MARK: - Following

extension ProfileViewModel {
    func follow() {
        Task {
            try await userService.follow(uid: user.id)
            user.isFollowed = true
            user.stats.followers += 1

            NotificationManager.shared.uploadFollowNotification(toUid: user.id)
        }
    }
    
    func unfollow() {
        Task {
            try await userService.unfollow(uid: user.id)
            user.isFollowed = false
            user.stats.followers -= 1
        }
    }
    
    func checkIfUserIsFollowed() async {
        guard !user.isCurrentUser, !didCompleteFollowCheck else { return }
        self.user.isFollowed = await userService.checkIfUserIsFollowed(uid: user.id)
        self.didCompleteFollowCheck = true
    }
}

