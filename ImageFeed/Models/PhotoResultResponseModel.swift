//
//  PhotoResultResponseModel.swift
//  ImageFeed
//
//  Created by Анастасия on 13.01.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: CGFloat
    let height: CGFloat
    let description: String?
    let isLiked: Bool
    let urls: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case description = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
    }
}

struct UrlsResult: Decodable {
    let largeImageURL: String?
    let thumbImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL = "full"
        case thumbImageURL = "thumb"
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
