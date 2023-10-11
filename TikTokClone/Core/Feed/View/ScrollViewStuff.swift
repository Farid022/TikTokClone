//
//  ScrollViewStuff.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import SwiftUI

struct ScrollViewStuff: View {
    @State private var position: Int?
    @State private var showingFirst = false
    @State private var showingSecond = false
    
    var body: some View {
        VStack {
            Text("Position: \(position ?? 0)")
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(0 ..< 100) { index in
                        ScrollViewStuffCell(index: index)
                            .id(index)
                            .onTapGesture {
                                showingFirst.toggle()
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $position)
        }
        .onChange(of: position, { oldValue, newValue in
            print("DEBUG: Scroll position changed..")
        })
        .sheet(isPresented: $showingFirst) {
            Button("Show Second Sheet") {
                showingSecond = true
            }
            
            .sheet(isPresented: $showingSecond) {
                Text("Second Sheet")
                    .presentationDetents([.height(80)])
            }
        }
    }
}

struct ScrollViewStuffCell: View {
    let index: Int
    
    init(index: Int) {
        self.index = index
        print("DEBUG: Did init..")
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.green)
            .overlay(Text("\(index)"))
            .containerRelativeFrame([.horizontal, .vertical])
    }
}

#Preview {
    ScrollViewStuff()
}
