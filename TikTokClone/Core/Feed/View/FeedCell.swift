import SwiftUI
import AVKit

struct FeedCell: View {
    @Binding var post: Post
    var player: AVPlayer
    @ObservedObject var viewModel: FeedViewModel
    @State private var expandCaption = false
    @State private var showComments = false
    @State private var isBlurred = false  // State property for blur effect
    
    private var didLike: Bool { return post.didLike }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .containerRelativeFrame([.horizontal, .vertical])
                .blur(radius: isBlurred ? 90 : 0)  // Apply blur based on isBlurred state

            if isBlurred {
                Text("Post Reported")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
            }

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
                            Spacer() // Add a Spacer to push the NavigationLink to the top

                            NavigationLink(value: post.user) {
                                ZStack(alignment: .bottom) {
                                    CircularProfileImageView(user: post.user, size: .medium)

                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.pink)
                                        .offset(y: 8)
                                }
                            }

                            Button {
                                
                            } label: {
//                                FeedCellActionButtonView(imageName: "magnifyingglass",
//                                                         value: post.shareCount)

                            }

                            Button {
                                handleLikeTapped()
                            } label: {
                                FeedCellActionButtonView(imageName: "suit.heart",
                                                         value: post.likes,
                                                         tintColor: didLike ? .red : .white)
                            }

                            Button {
                                player.pause()
                                showComments.toggle()
                            } label: {
                                FeedCellActionButtonView(imageName: "bubble", value: post.commentCount)
                            }

                            Button {
                                isBlurred.toggle()  // Toggle the blur effect
                            } label: {
                                FeedCellActionButtonView(imageName: "exclamationmark.circle",
                                                         value: post.shareCount)

                            }

                            Button {
                                
                            } label: {
//                                FeedCellActionButtonView(imageName: "x.circle",
//                                                         value: post.shareCount)

                            }
                        }
                        .padding(15)
                    }
                    .padding(.bottom, viewModel.isContainedInTabBar ? 80 : 12)
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
        Task { didLike ? await viewModel.unlike(post) : await viewModel.like(post) }
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(
            post: .constant(DeveloperPreview.posts[0]),
            player: AVPlayer(),
            viewModel: FeedViewModel(
                feedService: FeedService(),
                postService: PostService()
            )
        )
    }
}
