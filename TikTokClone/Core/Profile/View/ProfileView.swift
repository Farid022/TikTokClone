//
//  ProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    private var user: User {
        return viewModel.user
    }
    
    init(user: User) {
        let profileViewModel = ProfileViewModel(user: user, userService: UserService())
        self._viewModel = StateObject(wrappedValue: profileViewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ProfileHeaderView(viewModel: viewModel)
                
                PostGridView(viewModel: viewModel)
            }
        }
        .task { await viewModel.fetchPosts() }
        .task { await viewModel.checkIfUserIsFollowed() }
        .task { await viewModel.fetchUserStats() }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(user.username)
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
