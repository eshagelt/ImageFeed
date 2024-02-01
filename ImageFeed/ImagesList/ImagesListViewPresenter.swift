//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Анастасия on 01.02.2024.
//

import UIKit

public protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func makeAlert(with error: Error) -> UIAlertController
}

class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService()
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func makeAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.dismiss(animated: true)
        return alert
    }
}
