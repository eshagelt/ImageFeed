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
    private var lastLoadedPage: Int?
    private let dateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let request = fetchImagesListRequest(page: nextPage) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in

                guard let self = self else { return }
                
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(
                            Photo(
                                id: photoResult.id,
                                size: CGSize(width: photoResult.width, height: photoResult.height),
                                createdAt: photoResult.createdAt,
                                welcomeDescription: photoResult.description,
                                thumbImageURL: photoResult.urls?.thumbImageURL ?? "",
                                largeImageURL: photoResult.urls?.largeImageURL ?? "",
                                isLiked: photoResult.isLiked))
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                                            name: ImagesListService.didChangeNotification,
                                            object: self,
                                            userInfo: ["photos": photos])

                case .failure(let error):
                    assertionFailure("Ошибка получения изображений \(error)")
                }
            }
            self.task = task
            task.resume()
        }
}

private extension ImagesListService {
    func fetchImagesListRequest(page: Int, perPage: Int = 10) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
                    fatalError("Failed to get token")
                }
        
        var request = URLRequest.makeHTTPRequest(
            path: "/photos" + "?page=\(page)&per_page=10",
            httpMethod: "GET",
            baseURL: URL(string: "\(DefaultBaseApiUrl)")!)
        request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
