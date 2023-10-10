//
//  NotificationCell.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct NotificationCell: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    
    var notification: Notification {
        return viewModel.notification
    }
    
    var isFollowed: Bool {
        return notification.user?.isFollowed ?? false
    }
    
    init(notification: Notification) {
        self.viewModel = NotificationCellViewModel(notification: notification)
    }
    
    var body: some View {
        HStack {
            if let user = notification.user {
                
                NavigationLink(value: user) {
                    CircularProfileImageView(user: user, size: .xSmall)
                    
                    HStack {
                        Text(user.username)
                            .font(.system(size: 14, weight: .semibold)) +
                        
                        Text(notification.type.notificationMessage)
                            .font(.system(size: 14)) +
                        
                        Text(" 2d")
                            .foregroundColor(.gray).font(.system(size: 12))
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            if notification.type == .follow {
                Button(action: {
                    isFollowed ? viewModel.unfollow() : viewModel.follow()
                }, label: {
                    Text(isFollowed ? "Following" : "Follow")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 88, height: 32)
                        .foregroundColor(isFollowed ? .black : .white)
                        .background(isFollowed ? Color(.systemGroupedBackground) : Color.pink)
                        .cornerRadius(6)
                })
            } else {
                Image(notification.post?.thumbnailUrl ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NotificationCell(notification: DeveloperPreview.notifications[0])
}
