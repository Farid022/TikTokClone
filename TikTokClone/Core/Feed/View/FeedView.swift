//
//  FeedView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/6/23.
//

import SwiftUI
import AVKit

struct FeedView: View {
    @State private var player = AVPlayer()
    @StateObject var viewModel = FeedViewModel(service: FeedService())
    @State private var scrollPosition: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post, player: $player)
                            .id(post.id)
                            .onAppear { playInitialVideoIfNecessary(forPost: post) }
                    }
                }
                .scrollTargetLayout()
            }
            .onAppear { player.play() }
            .onDisappear { player.pause() }
            .overlay { if viewModel.isLoading { ProgressView() } }
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .onChange(of: scrollPosition, { oldValue, newValue in
                playVideoOnChangeOfScrollPosition(postId: newValue)
            })
        }
    }
    
    func playInitialVideoIfNecessary(forPost post: Post) {
        guard
            scrollPosition == nil,
            let post = viewModel.posts.first,
            player.currentItem == nil else { return }
        
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: post.videoUrl)!))
    }
    
    func playVideoOnChangeOfScrollPosition(postId: String?) {
        guard let currentPost = viewModel.posts.first(where: {$0.id == postId }) else { return }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: URL(string: currentPost.videoUrl)!)
        player.replaceCurrentItem(with: playerItem)
        
        if player.timeControlStatus == .paused {
            player.play()
        }
    }
}

#Preview {
    FeedView()
}
