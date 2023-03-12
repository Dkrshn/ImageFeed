//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 01.03.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let token = oAuth2TokenStorage.token else {
            return performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
        fetchProfile(token: token)
       self.switchToTabBarController()
   }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController else {
                fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        //UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code, completion: {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                    //UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print(error.localizedDescription)
                   // UIBlockingProgressHUD.dismiss()
                    self.showAllert()
                }

            }
        })
        }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                self.dismiss(animated: true)
                //UIBlockingProgressHUD.dismiss()
                self.fetchProfileImage(username: profile.userName)
            case .failure(let error):
                print(error.localizedDescription)
               // UIBlockingProgressHUD.dismiss()
                self.showAllert()
            }
        })
    }
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(userName: username, {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showAllert()
            }
        })
    }
   }

extension SplashViewController {
    func showAllert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: {_ in
            alert.dismiss(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}
