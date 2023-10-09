//
//  MainTabView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct MainTabView: View {
    private let authService: AuthService
    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var selectedTab = 0
    
    init(authService: AuthService) {
        self.authService = authService
    }
        
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .toolbarBackground(.black, for: .tabBar)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        
                        Text("Home")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            ExploreView()
                .toolbarBackground(.black, for: .tabBar)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "person.2.fill" : "person.2")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        
                        Text("Friends")
                    }
                }
                .onAppear { selectedTab = 1 }
                .tag(1)

            CurrentUserProfileView(service: authService)
                .toolbarBackground(.black, for: .tabBar)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        
                        Text("Profile")
                    }
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
        }
        .tint(.white)
    }
}

#Preview {
    MainTabView(authService: AuthService())
}
