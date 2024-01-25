//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Анастасия on 13.01.2024.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var lastLoadedPage: Int = 1
    private let dateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        guard let token = oauth2TokenStorage.token else { return }
        guard let request = fetchImagesListRequest(token, page: lastLoadedPage) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(Photo(result: photoResult))
                    }
                    
                    self.lastLoadedPage += 1
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                    
                case .failure(let error):
                    assertionFailure("Ошибка получения изображений \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = oauth2TokenStorage.token else { return }
        var request: URLRequest?
        if isLike {
            request = deleteLikeRequest(token, photoId: photoId)
        } else {
            request = likeRequest(token, photoId: photoId)
        }
        
        guard let request = request else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let photoResult):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo?.id}) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             width: photo.width,
                                             height: photo.height,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: !photo.isLiked)
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func likeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like", httpMethod: "POST", baseURL: DefaultBaseApiUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like", httpMethod: "DELETE", baseURL: DefaultBaseApiUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

private extension ImagesListService {
    func fetchImagesListRequest(_ token: String, page: Int, perPage: Int = 10) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "\(DefaultBaseApiUrl)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
