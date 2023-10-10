//
//  NotificationService.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

class NotificationService {
    
    func fetchNotifications() async throws -> [Notification] {
        return DeveloperPreview.notifications
    }
}
