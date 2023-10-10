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
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ProfileHeaderView(user: $viewModel.user)
                
                PostGridView(viewModel: viewModel)
            }
        }
        .task { await viewModel.fetchPosts() }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(user.username)
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
