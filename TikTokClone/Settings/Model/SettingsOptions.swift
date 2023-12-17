//
//  SettingsOptions.swift
//  TikTokClone
//
//  Created by Herbert Perryman on 12/12/23.
//

import Foundation

enum SettingsOptions: Int, CaseIterable, Identifiable {
    case notifications
    case privacy
    case account
    case help
    case about
    case deleteAccount
    
    var title: String {
        switch self {
        case .notifications: return "Notifications"
        case .privacy: return "Privacy"
        case .account: return "Account"
        case .help: return "Help"
        case .about: return "About"
        case .deleteAccount: return "Delete Account"

        }
    }
    
    var imageName: String {
           switch self {
           case .notifications: return "bell"
           case .privacy: return "lock"
        case .account: return "person.circle"
        case .help: return "questionmark.circle"
        case .about: return "info.circle"
           case .deleteAccount: return "Home"

        }
    }
    
    var id: Int { return self.rawValue }
}
