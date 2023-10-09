//
//  ContentViewModel.swift
//  TikTokClone
//
//  Created by Stephan Dowless on 10/9/23.
//

import Combine
import CoreLocation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private let userService: UserService
    
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        authService.$didAuthenticateUser.sink { [weak self] authenticated in
            self?.isAuthenticated = authenticated
            self?.fetchCurrentUser()
        }.store(in: &cancellables)
    }
    
    func fetchCurrentUser() {
        guard isAuthenticated else { return }
        Task { self.currentUser = try await userService.fetchCurrentUser() }
    }
}
