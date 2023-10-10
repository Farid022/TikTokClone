//
//  UserListService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

class UserListService {
    func fetchUsers() async throws -> [User] {
        return DeveloperPreview.users
    }
}
