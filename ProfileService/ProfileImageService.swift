//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 09.03.2023.
//

import Foundation

final class ProfileImageService {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    struct UserResult: Codable {
        let profileImage: ProfileImageURL
        
        enum CodingKeys: String, CodingKey{
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImageURL: Codable {
        let small: String
        let medium: String
    }
    
     func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
//         assert(Thread.isMainThread)
//        if task != nil {
//            task?.cancel()
//        }
         var request = URLRequest.makeHTTPRequest(path: "users/\(userName)", httpMethod: get)
         if let token = oAuth2TokenStorage.token {
             request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         }
         let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<UserResult, Error>) in
             guard let self = self else { return }
             switch result {
             case .success(let smallURL):
                 let newSmallURL = smallURL.profileImage.medium
                 self.avatarURL = newSmallURL
                 print(newSmallURL)
                 completion(.success(newSmallURL))
                 NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self,
                     userInfo: ["URL": newSmallURL])
             case .failure(let error):
                 completion(.failure(error))
             }
         })
     // self.task = task
        task.resume()
    }
}
