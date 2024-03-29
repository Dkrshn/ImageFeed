//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 28.02.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: Keys.token.rawValue) else {
                return nil
            }
            return token
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else {
                return
            }
        }
    }
    
    private enum Keys: String {
        case token
    }
    
    func removeToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
    }
}
