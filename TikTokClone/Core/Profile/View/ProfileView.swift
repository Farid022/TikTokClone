//
//  ProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @StateObject var viewModel: ProfileViewModel
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ProfileHeaderView(user: user)
                
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
