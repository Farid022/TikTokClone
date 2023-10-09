//
//  CommentsView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct CommentsView: View {
    @State private var commentText = ""
    @StateObject var viewModel: CommentViewModel
    
    init(post: Post) {
        let service = MockCommentService()
        self._viewModel = StateObject(wrappedValue: CommentViewModel(post: post, service: service))
    }
    
    var body: some View {
        VStack {
            if !viewModel.comments.isEmpty {
                Text(viewModel.commentCountText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 24)
            }
            
            Divider()
            
            List {
                VStack(spacing: 24) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            Divider()
                .padding(.bottom)
            
            HStack(spacing: 12) {
                CircularProfileImageView(user: DeveloperPreview.user, size: .xSmall)
                
                CommentInputView(inputText: $commentText, action: uploadComment)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .task { await viewModel.fetchComments() }
    }
    
    func uploadComment() {
        Task { await viewModel.uploadTestComment() }
    }
}

#Preview {
    CommentsView(post: DeveloperPreview.posts[0])
}
