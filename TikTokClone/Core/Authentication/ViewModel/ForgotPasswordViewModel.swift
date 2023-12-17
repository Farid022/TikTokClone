//
//  ForgotPasswordViewModel.swift
//  TikTokClone
//
//  Created by Herbert Perryman on 12/13/23.
//

import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var didSendEmail = false
    
    func sendPasswordResetEmail() async throws {
        do {
            try await AuthService.shared.sendResetPasswordLink(toEmail: email)
            didSendEmail = true
        } catch {
            // Handle errors here
            print("Error sending password reset email: \(error)")
        }
    }
}
