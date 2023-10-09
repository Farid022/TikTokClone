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
    var bio: String?
    var profileImageUrl: String? 
    
    var isFollowed: Bool?
}

extension User: Hashable { }
