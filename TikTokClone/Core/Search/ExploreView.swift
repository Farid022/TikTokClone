////
////  ExploreView.swift
////  TikTokClone
////
////  Created by Stephan Dowless on 10/9/23.
////
//
//import SwiftUI
//
//struct SearchBar: View {
//    @Binding var searchText: String
//
//    var body: some View {
//        HStack {
////            TextField("Search", text: $searchText)
////                .padding(.horizontal, 30) // Adjust the horizontal padding as needed
////                .padding(.vertical, 8)
////                .background(Color(.systemGray6))
////                .cornerRadius(8)
////                .overlay(
////                    HStack {
////                        Image(systemName: "magnifyingglass")
////                            .foregroundColor(.gray)
////                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
////                            .padding(.leading, 8)
////                    }
////                )
//        }
////        .padding(.horizontal, 16)
//    }
//}
//
//struct ExploreView: View {
//    @State private var searchText: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                SearchBar(searchText: $searchText)
//                    .padding(.top, 10)
//                    .padding(.bottom, 5)
//
//                UserListView()
//            }
//            .navigationBarTitle("Explore", displayMode: .inline)
//            .navigationDestination(for: User.self) { user in
//                ProfileView(user: user)
//            }
//        }
//    }
//}
//
//#if DEBUG
//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}
//#endif
//
//  ExploreView.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            UserListView()
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: User.self) { user in
                    ProfileView(user: user)
                }
        }
    }
}

#Preview {
    ExploreView()
}
