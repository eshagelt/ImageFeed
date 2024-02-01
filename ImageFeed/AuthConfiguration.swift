//
//  Constants.swift
//  ImageFeed
//
//  Created by Анастасия on 23.09.2023.
//

import Foundation

let AccessKey = "0RGQNJ9sxsXitjrwgcIRzNznsyygE8l8ZBPv3u8F1_s"
let SecretKey = "PGP5ucItXRWHTu9GbUoeXbe8LVr47vnLoxkLqNV2ZjI"
let RedirectURL = "urn:ietf:wg:oauth:2.0:oob"

let AccessScope = "public+read_user+write_likes"
let DefaultBaseUrl = URL(string: "https://unsplash.com")!
let DefaultBaseApiUrl = URL(string: "https://api.unsplash.com/")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURL: String
    let accessScope: String
    let defaultBaseURL: URL?
    let defaultBaseApiURL: URL?
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURL: RedirectURL,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseUrl,
                                 defaultBaseApiURL: DefaultBaseApiUrl,
                                 authURLString: UnsplashAuthorizeURLString
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
