//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 28.02.2023.
//

import Foundation

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
     var token: String {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let record = try? JSONDecoder().decode(String.self, from: data) else {
                return "Error: not find data"
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            userDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
    
    private enum Keys: String {
        case token
    }
}
