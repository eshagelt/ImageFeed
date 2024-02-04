//
//  Test.swift
//  ImageFeedTests
//
//  Created by Анастасия on 01.02.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testProfileViewControllerCalledViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testProfileViewControllerUpdateAvater() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = ApiConstants.DefaultBaseUrl
        
        //when
        presenter.view?.updateAvatar(url: url)
        
        //then
        XCTAssertTrue(viewController.didUpdateAvatar)
    }
    
    func testProfileViewControllerUpdateProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(result: ProfileResult(username: "", firstName: "", lastName: "", bio: ""))
        
        //when
        presenter.view?.updateProfileDetails(profile: profile)
        
        //then
        XCTAssertTrue(viewController.didUpdateProfileDetails)
    }
}
