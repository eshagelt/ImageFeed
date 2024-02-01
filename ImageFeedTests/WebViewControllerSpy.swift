//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Анастасия on 29.01.2024.
//

import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        <#code#>
    }
    
    func setProgressIsHidden(_ isHidden: Bool) {
        <#code#>
    }
}
