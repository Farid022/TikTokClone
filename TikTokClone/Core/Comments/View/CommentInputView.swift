//
//  CommentInputView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

import SwiftUI

struct CommentInputView: View {
    @Binding var inputText: String
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Add a comment", text: $inputText, axis: .vertical)
                .padding(10)
                .padding(.leading, 4)
                .padding(.trailing, 48)
                .background(Color(.systemGroupedBackground))
                .clipShape(Capsule())
                .font(.footnote)
                .overlay {
                    Capsule()
                        .stroke(Color(.systemGray5), lineWidth: 0)
                }
            
            Button(action: action) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.pink)
            }
            .padding(.horizontal)
        }
    }
}
