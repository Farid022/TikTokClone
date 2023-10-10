//
//  UserService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

import Foundation

class UserService {
    func fetchCurrentUser() async throws -> User {
        return DeveloperPreview.user
    }
}
