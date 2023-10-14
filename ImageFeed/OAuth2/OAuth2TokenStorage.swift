//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Анастасия on 03.10.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
