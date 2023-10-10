//
//  CurrentUserProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let service: AuthService
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    init(service: AuthService, user: User) {
        self.service = service
        self.user = user
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeaderView(user: user)
                        .padding(.top)
                    
                    PostGridView(viewModel: profileViewModel)
                }
            }
            .task { await profileViewModel.fetchPosts() }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CurrentUserProfileView(service: AuthService(), user: DeveloperPreview.user)
}
