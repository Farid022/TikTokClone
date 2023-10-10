//
//  UserService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import FirebaseAuth

enum UserError: Error {
    case unauthenticated
}

class UserService {
    func fetchCurrentUser() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else { throw UserError.unauthenticated }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
}
