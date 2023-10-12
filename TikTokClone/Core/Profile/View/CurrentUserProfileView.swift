//
//  CurrentUserProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let authService: AuthService
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    init(authService: AuthService, user: User) {
        self.authService = authService
        self.user = user
        
        let viewModel = ProfileViewModel(user: user, userService: UserService())
        self._profileViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeaderView(viewModel: profileViewModel)
                        .padding(.top)
                    
                    PostGridView(viewModel: profileViewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        authService.signout()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .task { await profileViewModel.fetchPosts() }
            .task { await profileViewModel.fetchUserStats() }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CurrentUserProfileView(authService: AuthService(),
                           user: DeveloperPreview.user)
}
