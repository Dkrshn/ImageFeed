//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 07.03.2023.
//

import Foundation

 final class ProfileService {
    
   // private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let shared = ProfileService()
     private let userDefaults = UserDefaults.standard
     
     private (set) var profile: Profile? {
         get {
             guard let data = userDefaults.data(forKey: Keys.profile.rawValue),
                   let record = try? JSONDecoder().decode(Profile.self, from: data) else {
                 return nil
             }
             return record
         }
         set {
             guard let data = try? JSONEncoder().encode(newValue) else {
                 print("Невозможно сохранить результат")
                 return
             }
             userDefaults.set(data, forKey: Keys.profile.rawValue)
         }
     }
     
     private enum Keys: String {
         case profile
     }
    
    struct ProfileResult: Decodable {
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String
        
        enum CodingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
        
    }
    
     struct Profile: Codable {
        let userName: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
      //  assert(Thread.isMainThread)
//        if task != nil {
//            task?.cancel()
//        } else {
//            return
//        }
        var request = URLRequest.makeHTTPRequest(path: profilePath, httpMethod: get)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = object(for: request, completion: {[weak self]result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let currentUser):
                    let profile: Profile = Profile.init(userName: currentUser.userName, name: "\(currentUser.firstName) \(currentUser.lastName)", loginName: "@\(currentUser.userName)", bio: currentUser.bio)
                    print(currentUser)
                    self.profile = profile
                    completion((.success(profile)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
        //self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func object(for request: URLRequest,
                        completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request, completion: {(result: Result<Data, Error>) in
            switch result {
            case .success(let data):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    print(json)
//                } catch {
//                    print("Failed to parse: )")
//                }
                do {
                    let object = try decoder.decode(ProfileResult.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
