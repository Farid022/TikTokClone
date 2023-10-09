//
//  CommentService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

protocol CommentServiceProtocol {
    func fetchComments() async throws -> [Comment]
}

class MockCommentService: CommentServiceProtocol {
    func fetchComments() async throws -> [Comment] {
        return DeveloperPreview.comments
    }    
}
