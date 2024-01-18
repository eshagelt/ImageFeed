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
        
        //let page = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = oauth2TokenStorage.token else { return }
        guard let request = fetchImagesListRequest(token, page: lastLoadedPage) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(self.convert(photoResult))
                    }
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                    self.lastLoadedPage += 1
                    
                case .failure(let error):
                    assertionFailure("Ошибка получения изображений \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convert(_ photoResult: PhotoResult) -> Photo {
        return Photo.init(id: photoResult.id,
                          size: CGSize(width: photoResult.width, height: photoResult.height),
                          createdAt: self.dateFormatter.date(from: photoResult.createdAt ?? ""),
                          welcomeDescription: photoResult.description,
                          thumbImageURL: photoResult.urls?.thumbImageURL ?? "",
                          largeImageURL: photoResult.urls?.largeImageURL ?? "",
                          isLiked: photoResult.isLiked)
    }
}

private extension ImagesListService {
    func fetchImagesListRequest(_ token: String, page: Int, perPage: Int = 10) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "\(DefaultBaseApiUrl)")!)
        request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
