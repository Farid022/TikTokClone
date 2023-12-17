import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    private var user: User {
        return viewModel.user
    }

    var isCurrentUser: Bool
    
    @State private var dragOffset = CGSize.zero

    init(user: User, isCurrentUser: Bool = false) {
        let profileViewModel = ProfileViewModel(user: user,
                                                userService: UserService(),
                                                postService: PostService())
        self._viewModel = StateObject(wrappedValue: profileViewModel)
        self.isCurrentUser = isCurrentUser
        
        UINavigationBar.appearance().tintColor = .primaryText
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ProfileHeaderView(viewModel: viewModel)
                PostGridView(viewModel: viewModel, isCurrentUser: isCurrentUser)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.dragOffset = gesture.translation
                }
                .onEnded { _ in
                    if self.dragOffset.width > 100 { // adjust this threshold as needed
                        // Swipe detected, navigate back
                        dismiss()
                    }
                    self.dragOffset = .zero
                }
        )
        .task { await viewModel.fetchUserPosts() }
        .task { await viewModel.checkIfUserIsFollowed() }
        .task { await viewModel.fetchUserStats() }
        .navigationTitle(user.username)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// Preview
#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: DeveloperPreview.user, isCurrentUser: true)
    }
}
#endif
