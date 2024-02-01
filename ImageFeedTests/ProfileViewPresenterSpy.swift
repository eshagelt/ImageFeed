//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTests
//
//  Created by Анастасия on 29.01.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
