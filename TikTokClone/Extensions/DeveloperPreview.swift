//
//  DeveloperPreview.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Foundation
import Firebase

struct DeveloperPreview {
    
    static var user = User(
        username: "lewis.hamilton",
        email: "lewis@gmail.com",
        fullname: "Lewis Hamilton", 
        bio: "Formula 1 Driver | Mercedes AMG",
        profileImageUrl: "lewis-hamilton"
    )
    
    private static let videoUrls =  [
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
    ]
    
    static var users: [User] = [
        .init(username: "lewis.hamilton", email: "lewis@gmail.com", fullname: "Lewis Hamilton", profileImageUrl: "lewis-hamilton"),
        .init(username: "max.verstappen", email: "max@gmail.com", fullname: "Max Verstappen", profileImageUrl: "max-verstappen"),
        .init(username: "fernando.alonso", email: "fernando@gmail.com", fullname: "Fernado Alonso", profileImageUrl: "fernando-alonso"),
        .init(username: "charles.leclerc", email: "charles@gmail.com", fullname: "Charles Leclerc", profileImageUrl: "charles-leclerc"),
    ]
    
    static var posts: [Post] = [
        .init(
            id: NSUUID().uuidString,
            videoUrl: videoUrls[3],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 200,
            commentCount: 57,
            saveCount: 23,
            shareCount: 9,
            views: 567,
            thumbnailUrl: "lewis-hamilton", 
            timestamp: Timestamp(),
            user: users[0]
        ),
        .init(
            id: NSUUID().uuidString,
            videoUrl: videoUrls[1],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 500,
            commentCount: 62,
            saveCount: 23,
            shareCount: 98,
            views: 841,
            thumbnailUrl: "max-verstappen",
            timestamp: Timestamp(),
            user: users[1]
        ),
        .init(
            id: NSUUID().uuidString,
            videoUrl: videoUrls[2],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 197,
            commentCount: 23,
            saveCount: 51,
            shareCount: 98,
            views: 937,
            thumbnailUrl: "fernando-alonso",
            timestamp: Timestamp(),
            user: users[2]
        ),
    ]
    
    static var comment = Comment(
        postOwnerUid: "test",
        commentText: "This is a test comment for preview purposes",
        postId: "",
        timestamp: Date(),
        commentOwnerUid: "",
        user: user
    )
    
    static var comments: [Comment] = [
        .init(
            postOwnerUid: "test",
            commentText: "This is a test comment for preview purposes",
            postId: "",
            timestamp: Date(),
            commentOwnerUid: "",
            user: user
        ),
        .init(
            postOwnerUid: "test",
            commentText: "This is another test comment so we have some mock data to work with",
            postId: "",
            timestamp: Date(),
            commentOwnerUid: "",
            user: users[1]
        ),
        .init(
            postOwnerUid: "test",
            commentText: "Final test comment to use in preview ",
            postId: "",
            timestamp: Date(),
            commentOwnerUid: "",
            user: users[2]
        ),
    ]
    
    static var notifications: [Notification] = [
        .init(postId: "", timestamp: Date(), type: .comment, uid: "lewis-hamilton", post: posts[0], user: user),
        .init(postId: "", timestamp: Date(), type: .like, uid: "max-verstappen", post: posts[2], user: users[3]),
        .init(postId: "", timestamp: Date(), type: .comment, uid: "lewis-hamilton", post: posts[1], user: user),
        .init(postId: "", timestamp: Date(), type: .comment, uid: "fernando-alonso", post: posts[0], user: users[2]),
        .init(timestamp: Date(), type: .follow, uid: "lewis-hamilton", user: users[1]),
        .init(postId: "", timestamp: Date(), type: .comment, uid: "lewis-hamilton", post: posts[1], user: user),
    ]
}
