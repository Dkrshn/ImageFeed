//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 28.02.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
     var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: Keys.token.rawValue) else {
                return nil
            }
            return token
//            guard let record = userDefaults.string(forKey: Keys.token.rawValue) else {
//                return nil
//            }
//            return record
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else {
                return
            }
            //userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}
