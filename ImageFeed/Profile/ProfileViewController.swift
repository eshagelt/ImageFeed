//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Анастасия on 11.09.2023.
//
import Foundation
import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails(profile: Profile?)
    func updateAvatar(url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let avatarImageView = UIImageView()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logoutButton") ?? UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapLogOutButton)
        )
        return button
    }()
    
    lazy var nameLabel = UILabel()
    lazy var loginNameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let splashViewController = SplashViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBackground
        
        let presenter = ProfileViewPresenter(view: self)
        
        setUpView()
        setUpConstraints()
        setupNotificationObserver()
        presenter.viewDidLoad()
        
    }
    
    func setupNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
            }
    }
    
    func setUpView() {
        avatarImageView.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        nameLabel.text = profileService.profile?.name
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = .systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.text = profileService.profile?.loginName
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.text = profileService.profile?.bio
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    private func setUpConstraints() {
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        
        loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc
    private func didTapLogOutButton(_ sender: Any?) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.logout()
        }
        
        let deleteAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)    
    }
    
    private func logout() {
        OAuth2TokenStorage.shared.removeToken()
        ProfileViewController.clean()
        guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
                    window.rootViewController = SplashViewController()
                    window.makeKeyAndVisible()
    }
}

extension ProfileViewController {
    func updateAvatar(url: URL) {
            let processor = RoundCornerImageProcessor(cornerRadius: 61)
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "placeholder"),
                                        options: [.processor(processor)])
            avatarImageView.layer.cornerRadius = 35
            avatarImageView.layer.masksToBounds = true
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile {
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            nameLabel.text = ""
            loginNameLabel.text = ""
            descriptionLabel.text = ""
        }
    }
}

extension ProfileViewController {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

