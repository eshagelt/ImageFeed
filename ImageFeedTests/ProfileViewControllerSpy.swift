//
//  ProfileViewControllerSpy.swift
//  ProfileViewTests
//
//  Created by Анастасия on 30.01.2024.
//

import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    var didUpdateAvatar: Bool = false
    var didUpdateProfileDetails: Bool = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        didUpdateProfileDetails = true
    }
    
    func updateAvatar(url: URL) {
        didUpdateAvatar = true
    }
}
