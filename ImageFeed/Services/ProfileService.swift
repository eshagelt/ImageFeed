//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Анастасия on 21.10.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    private init() {}

    func fetchProfile(authToken: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if profile != nil { return }
        task?.cancel()
        
        guard let request = makeRequest(token: authToken) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
                case .success(let profile):
                let profile = Profile(result: profile)
                self.profile = profile
                completion(.success(profile))
                
                case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        
    }
}

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
                    path: "/me",
                    httpMethod: "GET",
                    baseURL: URL(string: "https://unsplash.com")!)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return request
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = (result.firstName) + " " + (result.lastName)
        self.loginName = "@" + (result.username)
        self.bio = result.bio
    }
}

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case username, bio
    }
}
