//
//  FeedCell.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import SwiftUI
import AVKit

struct FeedCell: View {
    var player: AVPlayer
    @ObservedObject var viewModel: FeedViewModel
    @State private var expandCaption = false
    @State private var showComments = false
        
    var post: Post? {
        return viewModel.currentPost
    }
    
    private var didLike: Bool { return post?.didLike ?? false }
    private var didSave: Bool { return post?.didSave ?? false }
    
    init(post: Post, player: AVPlayer, viewModel: FeedViewModel) {
        self.player = player
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .containerRelativeFrame([.horizontal, .vertical])
                    
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, .black.opacity(0.15)],
                                             startPoint: .top,
                                             endPoint: .bottom))
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(post?.user?.username ?? "")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            
                            Text(post?.caption ?? "")
                                .lineLimit(expandCaption ? 50 : 2)
                            
                        }
                        .onTapGesture { withAnimation(.snappy) { expandCaption.toggle() } }
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding()
                        
                        Spacer()
                        
                        VStack(spacing: 28) {
                            NavigationLink(value: post?.user) {
                                ZStack(alignment: .bottom) {
                                    CircularProfileImageView(user: post?.user, size: .medium)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.pink)
                                        .offset(y: 8)
                                }
                            }
                            
                            Button {
                                handleLikeTapped()
                            } label: {
                                FeedItemActionButtonView(imageName: "heart.fill", 
                                                         value: post?.likes ?? 0,
                                                         tintColor: didLike ? .red : .white)
                            }
                            
                            Button {
                                player.pause()
                                showComments.toggle()
                            } label: {
                                FeedItemActionButtonView(imageName: "ellipsis.bubble.fill", value: post?.commentCount ?? 0)
                            }
                            
                            Button {
                                handleSaveTapped()
                            } label: {
                                FeedItemActionButtonView(imageName: "bookmark.fill",
                                                         value: post?.saveCount ?? 0,
                                                         height: 28,
                                                         width: 22,
                                                         tintColor: didSave ? .yellow : .white)
                            }
                            
                            Button {
                                
                            } label: {
                                FeedItemActionButtonView(imageName: "arrowshape.turn.up.right.fill", value: post?.shareCount ?? 0)
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, viewModel.isContainedInTabBar ? 80 : 12)
                }
            }
            .sheet(isPresented: $showComments) {
                if let post {
                    CommentsView(post: post)
                        .presentationDetents([.height(UIScreen.main.bounds.height * 0.65)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .large))
                }
            }
            .onTapGesture {
                switch player.timeControlStatus {
                case .paused:
                    player.play()
                case .waitingToPlayAtSpecifiedRate:
                    break
                case .playing:
                    player.pause()
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func handleLikeTapped() {
        guard let post else { return }
        Task { didLike ? await viewModel.unlike(post) : await viewModel.like(post) }
    }
    
    private func handleSaveTapped() {
//        Task { (post.didSave ?? false) ? await viewModel.unsave() : await viewModel.save() }
    }
}

struct FeedItemActionButtonView: View {
    let imageName: String
    let value: Int
    var height: CGFloat? = 28
    var width: CGFloat? = 28
    var tintColor: Color?
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: width, height: height)
                .foregroundStyle(tintColor ?? .white)
            
            if value > 0 {
                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .foregroundStyle(.white)
    }
}

//#Preview {
//    FeedCell(post: DeveloperPreview.posts[0])
//}
