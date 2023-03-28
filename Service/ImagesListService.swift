//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 17.03.2023.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var page: Int?
    private var perPage = 10
    static let shared = ImagesListService()
    
    private func makePhoto(_ photoResult: [PhotoResult]) {
        for i in photoResult {
            let photo = Photo(id: i.id, size: CGSize(width: Double(i.width), height: Double(i.height)), welcomeDescription: i.welcomeDescription, thumbImageURL: i.urls.thumb, largeImageURL: i.urls.full, isLiked: i.isLiked)
            photos.append(photo)
        }
        print("-----------------------\(photos.count)")
    }
    
    private func changeLike (_ photoId: String)  {
        if let index = photos.firstIndex(where: {$0.id == photoId}) {
            let photo = photos[index]
            print("------------------------------\(photo)")
            let newPhoto = Photo(id: photo.id, size: photo.size, welcomeDescription: photo.welcomeDescription, thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: !photo.isLiked)
            photos[index] = newPhoto
            print("--------------------------------------\(photos[index])")
        }
        }
        
        
        func fetchPhotosNextPage() {
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            assert(Thread.isMainThread)
            task?.cancel()
            var request = URLRequest.makeHTTPRequest(path: "\(photosPath)?page=\(nextPage)&&per_page=\(perPage)", httpMethod: get)
            if let token = oAuth2TokenStorage.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                print("-----------------------\(token)")
            }
            let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<[PhotoResult], Error>) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let photosResult):
                        self.makePhoto(photosResult)
                        print("-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-\(self.photos.count)")
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self, userInfo: ["photos": self.photos])
                    case .failure(_):
                        break
                    }
                }
            })
            self.task = task
            task.resume()
        }
        
        func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
            assert(Thread.isMainThread)
            task?.cancel()
            if !isLike {
                var request = URLRequest.makeHTTPRequest(path: "\(photosPath)/\(photoId)/like", httpMethod: post)
                if let token = oAuth2TokenStorage.token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PhotoLikeResult, Error>) in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        switch result {
                        case .success(let rus):
                            self.changeLike(photoId)
                            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(rus)")
                        case .failure(let error):
                            assertionFailure("\(error)")
                        }
                    }
                })
                self.task = task
                task.resume()
            } else {
                var request = URLRequest.makeHTTPRequest(path: "\(photosPath)/\(photoId)/like", httpMethod: delete)
                if let token = oAuth2TokenStorage.token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                    let task = urlSession.objectTask(for: request, completion: {[weak self] (result: Result<PhotoLikeResult, Error>) in
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            switch result {
                            case .success(let rus):
                                self.changeLike(photoId)
                                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\(rus)")
                            case .failure(let error):
                                assertionFailure("\(error)")
                            }
                        }
                    })
                self.task = task
                task.resume()
                }
            }
        }
