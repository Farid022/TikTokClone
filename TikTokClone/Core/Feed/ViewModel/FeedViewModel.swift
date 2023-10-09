//
//  FeedViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/6/23.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading = false
    private let service: FeedService
    
    init(service: FeedService) {
        self.service = service 
        Task { await fetchPosts() }
    }
    
    @MainActor
    func fetchPosts() async {
        isLoading = true
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            self.posts = try await service.fetchPosts()
            isLoading = false
        } catch {
            isLoading = false
            print("DEBUG: Failed to fetch posts \(error.localizedDescription)")
        }
    }
}
