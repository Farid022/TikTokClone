//
//  ScrollViewStuff.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import SwiftUI

struct ScrollViewStuff: View {
    @State private var position: Int?
    
    var body: some View {
        VStack {
            Text("Position: \(position ?? 0)")
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(0 ..< 100) { index in
                        Rectangle()
                            .fill(Color.green)
                            .overlay(Text("\(index)"))
                            .containerRelativeFrame([.horizontal, .vertical])
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $position)
        }
    }
}

#Preview {
    ScrollViewStuff()
}
