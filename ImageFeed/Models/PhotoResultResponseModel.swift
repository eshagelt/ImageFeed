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
    let welcomeDescription: String?
    let isLiked: Bool?
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let largeImageURL: String?
    let thumbImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL = "full"
        case thumbImageURL = "thumb"
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResult?
}
