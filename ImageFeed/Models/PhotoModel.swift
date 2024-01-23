//
//  PhotoModel.swift
//  ImageFeed
//
//  Created by Анастасия on 23.01.2024.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(result photo: PhotoResult) {
        self.init(id: photo.id,
                  width: CGFloat(photo.width),
                  height: CGFloat(photo.height),
                  createdAt: CustomDateFormatters.shared.iso8601DateFormatter.date(from: photo.createdAt ?? ""),
                  welcomeDescription: photo.welcomeDescription,
                  thumbImageURL: photo.urls?.thumbImageURL ?? "",
                  largeImageURL: photo.urls?.largeImageURL ?? "",
                  isLiked: photo.isLiked ?? false)
    }
}
