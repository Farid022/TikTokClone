import SwiftUI

struct CurrentUserProfileView: View {
    let authService: AuthService
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    init(authService: AuthService, user: User) {
        self.authService = authService
        self.user = user
        
        let viewModel = ProfileViewModel(user: user,
                                         userService: UserService(),
                                         postService: PostService())
        self._profileViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 2) {
                    ProfileHeaderView(viewModel: profileViewModel)
                        .padding(.top)
                    
                    // Pass true to isCurrentUser since it's the current user's profile
                    PostGridView(viewModel: profileViewModel, isCurrentUser: true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(authService: authService)) {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            .task { await profileViewModel.fetchUserPosts() }
            .task { await profileViewModel.fetchUserStats() }
            .navigationTitle(user.username) // Set the navigationTitle to user.username
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Preview provider
#if DEBUG
struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(authService: AuthService(),
                               user: DeveloperPreview.user)
    }
}
#endif
