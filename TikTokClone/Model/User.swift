//
//  User.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Foundation

struct User: Identifiable, Codable {
    var id = NSUUID().uuidString
    let username: String
    let email: String
    let fullname: String
    var bio: String?
    var profileImageUrl: String?
    
    var isFollowed: Bool?
    var stats: UserStats?
    
    var isCurrentUser: Bool {
        return username == "lewis.hamilton"
    }
}

extension User: Hashable { }



struct UserStats: Codable, Hashable {
    var following: Int
    var followers: Int
    var likes: Int
}
