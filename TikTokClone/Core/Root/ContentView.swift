//
//  ContentView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/6/23.
//

import SwiftUI

struct ContentView: View {
    private let authService: AuthService
    private let userService: UserService
    
    @StateObject var viewModel: ContentViewModel
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        
        let contentViewModel = ContentViewModel(authService: authService, userService: userService)
        self._viewModel = StateObject(wrappedValue: contentViewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated, let user = viewModel.currentUser {
                MainTabView(authService: authService, user: user)
                    .environmentObject(viewModel)
            } else {
//                LoginView(service: authService)
                MainTabView(authService: authService, user: DeveloperPreview.user)
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ContentView(authService: AuthService(), userService: UserService())
}
