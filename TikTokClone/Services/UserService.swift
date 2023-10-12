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
    
    func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
}

// MARK: - Following

extension UserService {
    func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .setData([:])
        
        async let _ = try FirestoreConstants
            .UserFollowerCollection(uid: uid)
            .document(currentUid)
            .setData([:])
    }
    
    func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        async let _ = try FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .delete()

        async let _ = try FirestoreConstants
            .UserFollowerCollection(uid: uid)
            .document(currentUid)
            .delete()
    }
    
    func checkIfUserIsFollowed(uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        guard let snapshot = try? await FirestoreConstants
            .UserFollowingCollection(uid: currentUid)
            .document(uid)
            .getDocument() else { return false }
        
        return snapshot.exists
    }
}
