//
//  Constants.swift
//  ImageFeed
//
//  Created by Анастасия on 23.09.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURL: String
    let accessScope: String
    let defaultBaseURL: URL?
    let defaultBaseApiURL: URL?
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: ApiConstants.AccessKey,
                                 secretKey: ApiConstants.SecretKey,
                                 redirectURL: ApiConstants.RedirectURL,
                                 accessScope: ApiConstants.AccessScope,
                                 defaultBaseURL: ApiConstants.DefaultBaseUrl,
                                 defaultBaseApiURL: ApiConstants.DefaultBaseApiUrl,
                                 authURLString: ApiConstants.UnsplashAuthorizeURLString
        )
    }
    
    init(accessKey: String, secretKey: String, redirectURL: String, accessScope: String, defaultBaseURL: URL?, defaultBaseApiURL: URL?, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURL = redirectURL
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.defaultBaseApiURL = defaultBaseApiURL
        self.authURLString = authURLString
    }
}
