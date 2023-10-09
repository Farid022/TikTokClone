//
//  Post.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Foundation

struct Post: Identifiable {
    var id = NSUUID().uuidString
    let videoUrl: String
    let ownerUid: String
    let caption: String
    var likes: Int
    var commentCount: Int
    var saveCount: Int
    var shareCount: Int
    
    var user: User?
    var didLike: Bool?
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }    
}
