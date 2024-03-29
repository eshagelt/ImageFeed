//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Анастасия on 28.10.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
            return
        }

        let request = fetchImageRequest(username)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
                case .success(let body):
                let avatarURL = body.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                
                case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

private extension ProfileImageService {
    func fetchImageRequest(_ username: String) -> URLRequest {
        guard let token = OAuth2TokenStorage.shared.token else {
            fatalError("Failed to get token")
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)",
                                                 httpMethod: "GET",
                                                 baseURL: ApiConstants.DefaultBaseApiUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
