//
//  ApiConstants.swift
//  ImageFeed
//
//  Created by Анастасия on 04.02.2024.
//

import Foundation

enum ApiConstants {
    static let AccessKey = "0RGQNJ9sxsXitjrwgcIRzNznsyygE8l8ZBPv3u8F1_s"
    static let SecretKey = "PGP5ucItXRWHTu9GbUoeXbe8LVr47vnLoxkLqNV2ZjI"
    static let RedirectURL = "urn:ietf:wg:oauth:2.0:oob"

    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseUrl = URL(string: "https://unsplash.com")!
    static let DefaultBaseApiUrl = URL(string: "https://api.unsplash.com/")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
