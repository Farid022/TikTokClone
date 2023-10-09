//
//  Comment.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id = NSUUID().uuidString
    let postOwnerUid: String
    let commentText: String
    let postId: String
    let timestamp: Date
    let commentOwnerUid: String
    
    var user: User?
}
