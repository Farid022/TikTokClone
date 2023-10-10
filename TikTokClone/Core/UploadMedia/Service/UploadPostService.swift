//
//  UploadPostService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

import Firebase

struct UploadPostService {
    func uploadPost(caption: String, videoUrlString: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = FirestoreConstants.PostsCollection.document()
        
        do {
            guard let url = URL(string: videoUrlString) else { return }
            guard let videoUrl = try await VideoUploader.uploadVideoToStorage(withUrl: url) else { return }
            
            let post = Post(
                id: ref.documentID,
                videoUrl: videoUrl,
                ownerUid: uid,
                caption: caption,
                likes: 0,
                commentCount: 0,
                saveCount: 0,
                shareCount: 0,
                views: 0,
                thumbnailUrl: "",
                timestamp: Timestamp()
            )

            guard let postData = try? Firestore.Encoder().encode(post) else { return }
            try await ref.setData(postData)
//            try await PostService.updateUserFeedsAfterPost(postId: ref.documentID)
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            throw error
        }
    }
}
