//
//  NotificationsView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel(service: NotificationService())

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.top)
                    }
                }

            }
            .navigationTitle("Updates")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.fetchNotifications() }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.showEmptyView {
                    ContentUnavailableView("No updates to show", systemImage: "bubble.middle.bottom")
                        .foregroundStyle(.gray)
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
        }
    }
}

#Preview {
    NotificationsView()
}
