//
//  CommentViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation


@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var commentText = "" 
    @Published var showEmptyView = false
    
    private let post: Post
    private let service: CommentService
    private let currentUser: User
    
    var commentCountText: String {
        return "\(comments.count) comments"
    }
    
    init(post: Post, service: CommentService, currentUser: User) {
        self.post = post
        self.service = service
        self.currentUser = currentUser
    }
    
    func fetchComments() async {
        do {
            self.comments = try await service.fetchComments()
            showEmptyView = comments.isEmpty
        } catch {
            print("DEBUG: Failed to fetch comments with error: \(error.localizedDescription)")
        }
    }
    
    func uploadComment() async {
        guard !commentText.isEmpty else { return }
        
        do {
            guard var comment = try await service.uploadComment(commentText: commentText) else { return }
            commentText = ""
            comment.user = currentUser
            comments.insert(comment, at: 0)
        } catch {
            print("DEBUG: Failed to upload comment with error \(error.localizedDescription)")
        }
    }
}
