//
//  FeedService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import Foundation

class FeedService {
    func fetchPosts() async throws -> [Post] {
        return DeveloperPreview.posts
    }
}
