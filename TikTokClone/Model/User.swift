//
//  User.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    var username: String
    let email: String
    let fullname: String
    var bio: String?
    var profileImageUrl: String?
    
    var isFollowed: Bool?
    var stats: UserStats?
    
    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
}

extension User: Hashable { }



struct UserStats: Codable, Hashable {
    var following: Int
    var followers: Int
    var likes: Int
}
