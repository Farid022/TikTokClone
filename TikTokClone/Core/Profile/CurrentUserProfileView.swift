//
//  CurrentUserProfileView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let service: AuthService
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CurrentUserProfileView(service: AuthService())
}
