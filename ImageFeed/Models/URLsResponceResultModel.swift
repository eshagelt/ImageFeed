//
//  URLsResponceResultModel.swift
//  ImageFeed
//
//  Created by Анастасия on 25.01.2024.
//

import Foundation

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
