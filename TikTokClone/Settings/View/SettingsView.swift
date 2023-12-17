import SwiftUI
import Firebase

struct SettingsView: View {
    @State private var showingDeleteAlert = false
    let authService: AuthService
    @State private var searchText: String = ""
    let settingsOptions = ["Delete Account", "Log Out"]

    init(authService: AuthService) {
        self.authService = authService
    }

    struct SearchBar: View {
        @Binding var searchText: String

        var body: some View {
            HStack {
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.gray) // Optional: Change the color of the magnifying glass icon
            }
            .padding(.horizontal)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                SearchBar(searchText: $searchText)

                List {
                    ForEach(settingsOptions.filter {
                        searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self) { option in
                        if option == "Delete Account" {
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text(option)
                                    .foregroundColor(.red)
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(
                                    title: Text("Are you sure?"),
                                    message: Text("Do you really want to delete your account? This action cannot be undone."),
                                    primaryButton: .destructive(Text("Delete")) {
                                        Task {
                                            await deleteAccount()
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        } else {
                            Button(action: {
                                authService.signout()
                            }) {
                                Text(option)
                            }
                        }
                    }
                }
                .background(Color.white) // Set the background color of the list to white

                Spacer()
            }
            .padding()
            .background(Color.black) // Set the background color of the entire VStack to black
            .navigationTitle("Settings and Privacy")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.black) // Set the background color of the entire view to black
    }

    private func deleteAccount() async {
        do {
            try await authService.deleteAccount()
            // Handle successful deletion, e.g., navigate to the login screen
            print("Account successfully deleted")
        } catch {
            // Handle error
            print("Error deleting account: \(error.localizedDescription)")
        }
    }
}
