//
//  Post.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import AVKit

struct Post: Identifiable, Codable {
    let id: String
    let videoUrl: String
    let ownerUid: String
    let caption: String
    var likes: Int
    var commentCount: Int
    var saveCount: Int
    var shareCount: Int
    var views: Int
    var thumbnailUrl: String
    var timestamp: Timestamp
    
    var user: User?
    var didLike: Bool?
    var didSave: Bool?
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }    
}
