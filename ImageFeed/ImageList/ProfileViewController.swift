//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 03.02.2023.
//

import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let webViewViewController = WebViewViewController()
    
    private let profilePhoto = UIImageView()
    private let profileName = UILabel()
    private let profileContact = UILabel()
    private let profileAbout = UILabel()
    private let logOutButton = UIButton.systemButton(with: UIImage(named: "ipad.and.arrow.forward")!, target: nil, action: #selector(Self.didTapButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) {[weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func makeUI() {
        view.backgroundColor = .ypBlack
        
        let allViewOnScreen = [profilePhoto, profileName, profileContact, profileAbout, logOutButton]
        allViewOnScreen.forEach {view.addSubview($0)}
        allViewOnScreen.forEach {$0.translatesAutoresizingMaskIntoConstraints = false}
        
        
        
        profileName.text = profileService.profile?.name
        print(profileName.text = profileService.profile?.name)
        profileName.font = UIFont.boldSystemFont(ofSize: 23)
        profileName.textColor = .ypWhite
        
        profileContact.text = profileService.profile?.loginName
        profileContact.font = UIFont.systemFont(ofSize: 13)
        profileContact.textColor = .ypGray
        
        profileAbout.text = profileService.profile?.bio
        profileAbout.font = UIFont.systemFont(ofSize: 13)
        profileAbout.textColor = .ypWhite
        
        logOutButton.tintColor = .ypRed
        
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileName.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileName.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            profileAbout.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileAbout.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileContact.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            profileContact.topAnchor.constraint(equalTo: profileAbout.bottomAnchor, constant: 8),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logOutButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor)
        ])
    }
    
    
    @objc
    private func didTapButton() {
        showAlert()
    }
    
    private func exit() {
        oAuth2TokenStorage.removeToken()
        WebViewViewController.clean()
        guard let window = UIApplication.shared.windows.first else { return assertionFailure("Invalid Configuration") }
        let authVC = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewController")
        window.rootViewController = authVC
    }
    
}

extension ProfileViewController {
    private func updateAvatar() {
        guard  let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL)  else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61, backgroundColor: .clear)
        profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpeg"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        profilePhoto.kf.indicatorType = .activity
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.exit()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
    }
}

