//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Анастасия on 01.02.2024.
//

import UIKit
import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func makeAlert(with error: Error) -> UIAlertController {
        UIAlertController()
    }
    
    func fetchPhotosNextPage() {
        let oldCount = 10
        let newCount = 20
        if oldCount < newCount {
            view?.updateTableViewAnimated()
        }
    }
}
