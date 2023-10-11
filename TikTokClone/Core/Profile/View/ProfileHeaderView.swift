//
//  ProfileHeaderView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State private var showEditProfile = false
    @Binding var user: User
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                CircularProfileImageView(user: user, size: .xLarge)
                
                Text("@\(user.username)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            // stats view
            HStack(spacing: 16) {
                UserStatView(value: user.stats?.following, title: "Following")

                UserStatView(value: user.stats?.followers, title: "Followers")
                
                UserStatView(value: user.stats?.likes, title: "Likes")
            }
            
            // action button view
            if user.isCurrentUser {
                Button {
                    showEditProfile.toggle()
                } label: {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 360, height: 32)
                        .foregroundStyle(.black)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            } else {
                Button {
                    
                } label: {
                    Text("Follow")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 360, height: 32)
                        .foregroundStyle(.white)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            
            // bio
            if let bio = user.bio {
                Text(bio)
                    .font(.subheadline)
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileView(user: $user)
        }
    }
}

struct UserStatView: View {
    let value: Int?
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value ?? 40)")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .opacity(value == 0 ? 0.5 : 1.0)
        .frame(width: 80, alignment: .center)
    }
}

#Preview {
    ProfileHeaderView(user: .constant(DeveloperPreview.user))
}
