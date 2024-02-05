//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Анастасия on 01.02.2024.
//

import UIKit
import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var imagesListService: ImageFeed.ImagesListService
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var changeLikeCalled: Bool = false
    
    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotos() {
        let oldCount = 10
        let newCount = 20
        if oldCount < newCount {
            view?.updateTableViewAnimated()
        }
    }
    
    func presentChangeLikeResult(photo: ImageFeed.Photo, completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
}
