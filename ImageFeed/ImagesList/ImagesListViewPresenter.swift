//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Анастасия on 01.02.2024.
//

import UIKit

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    func viewDidLoad()
    func presentChangeLikeResult(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    let imagesListService = ImagesListService.shared
    
    var photos: [Photo] = []
    
    func viewDidLoad() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func presentChangeLikeResult(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
            imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked, completion)
        }
}
