//
//  ScrollViewStuff.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/8/23.
//

import SwiftUI

class ScrollViewStuffViewModel: ObservableObject {
    @Published var items = [Int]()
    
    init() {
        self.items = Array(0 ..< 100)
    }
}

struct ScrollViewStuff: View {
    @State private var position: Int?
    @State private var showingFirst = false
    @State private var showingSecond = false
    @StateObject var viewModel = ScrollViewStuffViewModel()
    
    var body: some View {
        VStack {
            Text("Position: \(position ?? 0)")
            Button("Scroll To Bottom") {
                position = 99
            }
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.items, id: \.self) { index in
                        ScrollViewStuffCell(index: index)
                            .environmentObject(viewModel)
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
    @EnvironmentObject var viewModel: ScrollViewStuffViewModel
    
    init(index: Int) {
        self.index = index
        print("DEBUG: Did init..")
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.green)
            .overlay(Text("\(index) / \(viewModel.items.count)"))
            .containerRelativeFrame([.horizontal, .vertical])
    }
}

#Preview {
    ScrollViewStuff()
}
