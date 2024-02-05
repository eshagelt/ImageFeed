//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Анастасия on 29.01.2024.
//

import Foundation
import WebKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        checkAvatar()
        checkProfile()
    }
    
    func checkAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
    
    func checkProfile() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
}
