//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 27.02.2023.
//

import Foundation

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    
    private var lastCode: String?
    
    private var task: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            guard let newValue = newValue else { return }
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = object(for: request) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
               }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest,
                        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        return urlSession.objectTask(for: request, completion: {[weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                completion(.failure(error))
            }
        })
 }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/oauth/token"
                                   + "?client_id=\(accessKey)"
                                   + "&&client_secret=\(secretKey)"
                                   + "&&redirect_uri=\(redirectURI)"
                                   + "&&code=\(code)"
                                   + "&&grant_type=authorization_code",
                                   httpMethod: "POST",
                                   baseURL: URL(string: "https://unsplash.com")!)
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}

// MARK: - HTTP Request

//extension URLRequest {
//    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = defaultBaseURL) -> URLRequest {
//        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
//        request.httpMethod = httpMethod
//        return request
//    }
//}
//
//// MARK: - Network Connection
//
//private enum NetworkError: Error {
//    case httpStatusCode(Int)
//    case urlRequestError(Error)
//    case urlSessionError
//}
//
//
//extension URLSession {
//    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
//        let fullfillCompletion: (Result<T, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        let task = dataTask(with: request, completionHandler: {data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(T.self, from: data)
//                        fullfillCompletion(.success(result))
//                        } catch {
//                            fullfillCompletion(.failure(error))
//                        }
//                        } else {
//                            fullfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
//                        }
//                        }else if let error {
//                            fullfillCompletion(.failure(NetworkError.urlRequestError(error)))
//                        } else {
//                            fullfillCompletion(.failure(NetworkError.urlSessionError))
//                        }
//                        })
//                        task.resume()
//                        return task
//                    }
//                }
