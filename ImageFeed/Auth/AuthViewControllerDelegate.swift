//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Анастасия on 03.10.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
