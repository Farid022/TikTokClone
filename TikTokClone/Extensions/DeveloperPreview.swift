//
//  DeveloperPreview.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Foundation

struct DeveloperPreview {
    
    static var user = User(username: "lewis.hamilton", email: "lewis@gmail.com", profileImageUrl: "lewis-hamilton")
    
    private static let videoUrls =  [
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
    ]
    
    static var users: [User] = [
        .init(username: "lewis.hamilton", email: "lewis@gmail.com", profileImageUrl: "lewis-hamilton"),
        .init(username: "max.verstappen", email: "max@gmail.com", profileImageUrl: "max-verstappen"),
        .init(username: "fernando.alonso", email: "fernando@gmail.com", profileImageUrl: "fernando-alonso"),
        .init(username: "charles.leclerc", email: "charles@gmail.com", profileImageUrl: "charles-leclerc"),
    ]
    
    static var posts: [Post] = [
        .init(
            videoUrl: videoUrls[3],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 200,
            commentCount: 57,
            saveCount: 23,
            shareCount: 9,
            user: users[0]
        ),
        .init(
            videoUrl: videoUrls[1],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 500,
            commentCount: 62,
            saveCount: 23,
            shareCount: 98,
            user: users[1]
        ),
        .init(
            videoUrl: videoUrls[2],
            ownerUid: "lewis.hamilton",
            caption: "This is some test caption for this post",
            likes: 197,
            commentCount: 23,
            saveCount: 51,
            shareCount: 98,
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
}
