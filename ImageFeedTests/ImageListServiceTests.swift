//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Анастасия on 13.01.2024.
//
@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
