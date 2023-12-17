import SwiftUI
import AVKit

struct MainTabView: View {
    private let authService: AuthService
    private let user: User
    @State private var selectedTab = 0
    @State private var player = AVPlayer()
    @State private var playbackObserver: NSObjectProtocol?

    init(authService: AuthService, user: User) {
        self.authService = authService
        self.user = user
        
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // <- Here to remove the TabView Background...

        UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView(player: $player)
                //.toolbarBackground(.black, for: .tabBar)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "play.rectangle.fill" : "play.rectangle")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)

            ExploreView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "magnifyingglass" : "magnifyingglass")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)

                        Text("Search")
                    }
                }
                .onAppear { selectedTab = 1 }
                .tag(1)

            MediaSelectorView(tabIndex: $selectedTab)
                .tabItem { Image(systemName: "plus") }
                .onAppear { selectedTab = 2 }
                .tag(2)

            NotificationsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)

                        Text("Inbox")
                    }
                }
                .onAppear { selectedTab = 3 }
                .tag(3)

            CurrentUserProfileView(authService: authService, user: user)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 4 ? "person.crop.rectangle.fill" : "person.crop.rectangle")
                            .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)

                        Text("Profile")
                    }
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
        }
        .onAppear { configurePlaybackObserver() }
        .onDisappear { removePlaybackObserver() }
        .tint(selectedTab == 0 ? .white : .primaryText)
        .background(Color.clear) // Make the TabView background transparent
        .accentColor(.clear) // Make the TabItem text color transparent
    }

    func configurePlaybackObserver() {
        self.playbackObserver = NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification,
                                                                       object: nil,
                                                                       queue: .main) { _ in
            if player.timeControlStatus == .playing {
                self.player.seek(to: CMTime.zero)
                self.player.play()
            }
        }
    }

    func removePlaybackObserver() {
        if let playbackObserver = playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver,
                                                      name: AVPlayerItem.didPlayToEndTimeNotification,
                                                      object: nil)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authService: AuthService(), user: DeveloperPreview.user)
    }
}
