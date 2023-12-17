import SwiftUI
import Kingfisher
import AVKit
import FirebaseFirestore
import FirebaseStorage

struct PostGridView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var player = AVPlayer()
    @State private var selectedPost: Post?
    @State private var showingOptionsForPost: Post?
    
    // Add isCurrentUser as a property of the view
    var isCurrentUser: Bool

    private let items = [
        GridItem(.flexible(), spacing: 1),
    ]
    private let width = (UIScreen.main.bounds.width / 3) - 2
    
    var body: some View {
        LazyVGrid(columns: items, spacing: 2) {
            ForEach(viewModel.posts) { post in
                ZStack(alignment: .topTrailing) {
                    KFImage(URL(string: post.thumbnailUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: 160)
                        .clipped()
                    
                    // Check if the current user is viewing their own profile
                    if isCurrentUser {
                        Button(action: {
                            showingOptionsForPost = post
                            print("Tapped ellipsis for post: \(post.id)")
                        }) {
                            Image(systemName: "ellipsis")
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        .actionSheet(item: $showingOptionsForPost) { _ in
                            ActionSheet(title: Text("Options"), message: Text("Select an option"), buttons: [
                                .destructive(Text("Delete Post")) {
                                    deletePost(post)
                                },
                                .cancel()
                            ])
                        }
                    }
                }
                .onTapGesture { selectedPost = post }
                .background(Color.red) // Debugging background color
            }
        }
        .sheet(item: $selectedPost) { post in
            FeedView(player: $player, posts: [post])
                .onDisappear {
                    player.replaceCurrentItem(with: nil)
                }
        }
    }

    private func deletePost(_ post: Post) {
        print("Deleting post: \(post.id)")

        // Create a reference to the Firebase Storage
        let storage = Storage.storage()
        
        if let url = URL(string: post.thumbnailUrl),
           let filePath = storage.storagePath(for: url) {
            storage.reference(withPath: filePath).delete { error in
                if let error = error {
                    print("Error deleting file from Firebase Storage: \(error)")
                } else {
                    print("File successfully deleted from Firebase Storage")
                    deletePostFromFirestore(post)
                }
            }
        } else {
            deletePostFromFirestore(post)
        }
    }

    private func deletePostFromFirestore(_ post: Post) {
        let db = Firestore.firestore()
        db.collection("posts").document(post.id).delete { error in
            if let error = error {
                print("Error removing document from Firestore: \(error)")
            } else {
                print("Document successfully removed from Firestore")
                if let index = viewModel.posts.firstIndex(where: { $0.id == post.id }) {
                    viewModel.posts.remove(at: index)
                }
            }
        }
    }
}

extension Storage {
    func storagePath(for url: URL) -> String? {
        let pathComponents = url.pathComponents

        if let oIndex = pathComponents.firstIndex(of: "o"), oIndex + 1 < pathComponents.count {
            let filePathComponents = pathComponents.dropFirst(oIndex + 1)
            return filePathComponents.joined(separator: "/").removingPercentEncoding
        }
        return nil
    }
}

// Preview
struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridView(viewModel: ProfileViewModel(
            user: DeveloperPreview.user,
            userService: UserService(),
            postService: PostService()),
            isCurrentUser: true // Set this to true or false based on the context
        )
    }
}
