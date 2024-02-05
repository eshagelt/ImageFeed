//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Анастасия on 01.02.2024.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    var didUpdateTableView: Bool = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func updateTableViewAnimated() {
        didUpdateTableView = true
    }
}
