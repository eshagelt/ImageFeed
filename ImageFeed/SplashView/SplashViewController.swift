//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Анастасия on 09.10.2023.
//
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAutentificationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAutentificationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAutentificationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAutentificationScreenSegueIdentifier)")}
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
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
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authToken):
                self.fetchProfile(authToken)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ authToken: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(authToken: authToken) { [weak self ] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(username: username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showAlert()
                break
            }
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
