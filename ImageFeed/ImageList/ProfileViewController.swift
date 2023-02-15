//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 03.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .YPBlack
        let profilePhoto = UIImageView()
        let profileName = UILabel()
        let profileContact = UILabel()
        let profileAbout = UILabel()
        let logOutButton = UIButton.systemButton(with: UIImage(named: "ipad.and.arrow.forward")!, target: nil, action: nil)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileContact.translatesAutoresizingMaskIntoConstraints = false
        profileAbout.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profilePhoto)
        view.addSubview(profileName)
        view.addSubview(profileContact)
        view.addSubview(profileAbout)
        view.addSubview(logOutButton)
        
        profilePhoto.image = UIImage(named: "Photo")

        
        profileName.text = "Екатерина Новикова"
        profileName.font = UIFont.boldSystemFont(ofSize: 23)
        profileName.textColor = .YPWhite
        
        profileContact.text = "@ekaterina_nov"
        profileContact.font = UIFont.systemFont(ofSize: 13)
        profileContact.textColor = .YPGray
        
        profileAbout.text = "Hello, world!"
        profileAbout.font = UIFont.systemFont(ofSize: 13)
        profileAbout.textColor = .YPWhite
        
        logOutButton.tintColor = .YPRed
        
        
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
}

