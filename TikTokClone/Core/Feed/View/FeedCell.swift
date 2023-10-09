//
//  FeedCell.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import SwiftUI
import AVKit

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    @Binding var player: AVPlayer
    @State private var expandCaption = false
    @State private var showComments = false
    
    private var post: Post { return viewModel.post }
    private var didLike: Bool { return viewModel.post.didLike ?? false }
    
    init(post: Post, player: Binding<AVPlayer>) {
        self._player = player
        self.viewModel = FeedCellViewModel(post: post)
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
                            Text(post.user?.username ?? "")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            
                            Text(post.caption)
                                .lineLimit(expandCaption ? 50 : 2)
                            
                        }
                        .onTapGesture { withAnimation(.snappy) { expandCaption.toggle() } }
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding()
                        
                        Spacer()
                        
                        VStack(spacing: 28) {
                            NavigationLink(value: post.user) {
                                ZStack(alignment: .bottom) {
                                    CircularProfileImageView(user: post.user, size: .medium)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.pink)
                                        .offset(y: 8)
                                }
                            }
                            
                            Button {
                                handleLikeTapped()
                            } label: {
                                FeedItemActionButtonView(imageName: "heart.fill", value: post.likes, tintColor: didLike ? .red : .white)
                            }
                            
                            Button {
                                showComments.toggle()
                            } label: {
                                FeedItemActionButtonView(imageName: "ellipsis.bubble.fill", value: post.commentCount)
                            }
                            
                            Button {
                                
                            } label: {
                                FeedItemActionButtonView(imageName: "bookmark.fill", value: post.saveCount, height: 28, width: 22)
                            }
                            
                            Button {
                                
                            } label: {
                                FeedItemActionButtonView(imageName: "arrowshape.turn.up.right.fill", value: post.shareCount)
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 80)
                }
            }
            .sheet(isPresented: $showComments) {
                CommentsView(post: post)
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.65)])
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
        Task { didLike ? try await viewModel.unlike() : try await viewModel.like() }
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
