//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Анастасия on 09.10.2023.
//
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var unsplashLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            guard let authToken = oauth2TokenStorage.token else { return }
            fetchProfile(authToken)
        } else {
            showAuthViewController()
        }
    }
    
    private func showAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    private func setupSplashView() {
        view.backgroundColor = .ypBackground
        view.addSubview(unsplashLogoImage)
        
        NSLayoutConstraint.activate([
            unsplashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            fetchOAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
    
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authToken):
                self.fetchProfile(authToken)
            case .failure:
                self.showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(_ authToken: String) {        
        profileService.fetchProfile(authToken: authToken) { [weak self ] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(username: username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlert()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так :(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
