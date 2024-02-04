//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Анастасия on 29.01.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let imagesListService = ImagesListService()
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testDidUpdateTableView() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let imagesListService = ImagesListService()
        let presenter = ImagesListViewPresenterSpy(imagesListService: imagesListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.fetchPhotos()
        
        //then
        XCTAssertTrue(viewController.didUpdateTableView)
    }

}
