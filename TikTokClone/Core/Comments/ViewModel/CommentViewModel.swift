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
    
    private let post: Post
    private let service: CommentServiceProtocol
    
    var commentCountText: String {
        return "\(comments.count) comments"
    }
    
    init(post: Post, service: CommentServiceProtocol) {
        self.post = post
        self.service = service
    }
    
    func fetchComments() async {
        do {
            self.comments = try await service.fetchComments()
        } catch {
            print("DEBUG: Failed to fetch comments with error: \(error.localizedDescription)")
        }
    }
    
    func uploadTestComment() async {
        self.comments.append(DeveloperPreview.comment)
    }
}
