//
//  NotificationsViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    @Published var isLoading = false
    
    private let service: NotificationService
    
    init(service: NotificationService) {
        self.service = service
        Task { await fetchNotifications() }
    }
    
    func fetchNotifications() async {
        do {
            self.notifications = try await service.fetchNotifications()
        } catch {
            print("DEBUG: Failed to fetch notifications with error \(error.localizedDescription)")
        }
    }
}
