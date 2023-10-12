//
//  PostGridView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct PostGridView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    private let width = (UIScreen.main.bounds.width / 3) - 2
    
    var body: some View {
        LazyVGrid(columns: items, spacing: 2, content: {
            ForEach(viewModel.posts) { post in
                if let image = MediaHelpers.generateThumbnail(path: post.videoUrl) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: 160)
                        .clipped()
                }
            }
        })
    }
}

#Preview {
    PostGridView(viewModel: ProfileViewModel(user: DeveloperPreview.user, userService: UserService()))
}
