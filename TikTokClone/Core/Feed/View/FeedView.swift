import SwiftUI
import AVKit
import AppTrackingTransparency

struct FeedView: View {
    @Binding var player: AVPlayer
    @StateObject var viewModel: FeedViewModel
    @State private var scrollPosition: String?
    
    init(player: Binding<AVPlayer>, posts: [Post] = []) {
        self._player = player
        
        // Shuffle the posts array
        let shuffledPosts = posts.shuffled()
        
        // Initialize the view model
        let viewModel = FeedViewModel(
            feedService: FeedService(),
            postService: PostService(),
            posts: shuffledPosts
        )
        self._viewModel = StateObject(wrappedValue: viewModel)

        // Call requestTrackingPermission() when the view is initialized
        self.requestTrackingPermission()
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach($viewModel.posts) { post in
                            FeedCell(post: post, player: player, viewModel: viewModel)
                                .id(post.id)
                                .onAppear { playInitialVideoIfNecessary(forPost: post.wrappedValue) }
                        }
                    }
                    .scrollTargetLayout()
                }
                .onAppear {
                    // Hide scroll indicators when the ScrollView appears
                    UIScrollView.appearance().showsVerticalScrollIndicator = false
                    UIScrollView.appearance().showsHorizontalScrollIndicator = false
                }
                
                Button {
                    Task { await viewModel.refreshFeed() }
                } label: {
                    Text("Flow")
                        .font(.system(size: 22, weight: .bold)) // Adjust the size and weight as needed
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(.top, 20)
                        .padding(40)
                }
            }
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .ignoresSafeArea(.all, edges: .top)
            .background(.black)
            .onAppear { player.play() }
            .onDisappear { player.pause() }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.showEmptyView {
                    ContentUnavailableView("No posts to show", systemImage: "eye.slash")
                        .foregroundStyle(.white)
                }
            }
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .onChange(of: scrollPosition, { oldValue, newValue in
                playVideoOnChangeOfScrollPosition(postId: newValue)
                //handleTabState(newValue)
            })
            .toolbar(tabState, for: .tabBar)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "video.badge.plus")
                    .foregroundColor(.white)
                    .font(Font.system(size:23,weight: .bold))
                    .padding(.trailing)
            } 
            
        }
    }
    
    // Request tracking permission when needed
    private func requestTrackingPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // User granted permission, you can now track
                    print("Tracking authorized")
                case .denied:
                    // User denied permission, handle accordingly
                    print("Tracking denied")
                case .notDetermined:
                    // Tracking permission has not been requested yet
                    print("Tracking not determined")
                case .restricted:
                    // Tracking is restricted, e.g., due to parental controls
                    print("Tracking restricted")
                @unknown default:
                    break
                }
            }
        }
    }
    
    // Play initial video if necessary
    private func playInitialVideoIfNecessary(forPost post: Post) {
        guard
            scrollPosition == nil,
            let post = viewModel.posts.first,
            player.currentItem == nil,
            let videoURL = URL(string: post.videoUrl)
        else {
            return
        }
        
        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }
    
    // Play video when scroll position changes
    private func playVideoOnChangeOfScrollPosition(postId: String?) {
        guard let currentPost = viewModel.posts.first(where: { $0.id == postId }), let videoURL = URL(string: currentPost.videoUrl) else {
            return
        }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = AVPlayerItem(url: videoURL)
        player.replaceCurrentItem(with: playerItem)
    }
    
    
    //MARK: Updated - Farid Khan work
    @State private var tabState: Visibility = .visible
    private func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let offsetY = gesture.translation(in: gesture.view).y
        let velocityY = gesture.velocity(in: gesture.view).y
        
        if velocityY < 0 {
            if -(velocityY / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            if (velocityY / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
        print("Y IS \(offsetY)")
    }
    fileprivate struct CustomGesture: UIViewRepresentable {
        var onChange: (UIPanGestureRecognizer) -> ()
        
        private let gestureID = "AB443CB7-84D3-4F46-A27D-8555D5B352EE"
        
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(onChange: onChange)
        }
        func makeUIView(context: Context) -> some UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            DispatchQueue.main.async {
                if let superview = uiView.superview?.superview, !(superview.gestureRecognizers?.contains(where: {$0.name == gestureID}) ?? false ) {
                        let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                        gesture.name = gestureID
                        gesture.delegate = context.coordinator
                        superview.addGestureRecognizer(gesture)
                    }
                }
            }
        
        class Coordinator: NSObject, UIGestureRecognizerDelegate {
            var onChange: (UIPanGestureRecognizer) -> ()
            init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
                self.onChange = onChange
            }
            
            @objc func gestureChange(gesture: UIPanGestureRecognizer) {
                onChange(gesture)
            }
            
            func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
                return true
            }
        }
    }
}
