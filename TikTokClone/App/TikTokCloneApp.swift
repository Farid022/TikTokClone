//
//  TikTokCloneApp.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/6/23.
//

import SwiftUI

@main
struct TikTokCloneApp: App {
    private let authService = AuthService()
    private let userService = UserService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(authService: authService, userService: userService)
                .toolbarBackground(.black, for: .tabBar)
        }
    }
}
