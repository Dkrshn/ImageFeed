//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 21.02.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            let viewController = segue.destination as! WebViewViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func makeUI() {
        view.backgroundColor = .YPBlack
        let auth_screen_logo = UIImageView()
        let button = UIButton()
        auth_screen_logo.image = UIImage(named: "AuthView")
        view.addSubview(auth_screen_logo)
        view.addSubview(button)
        auth_screen_logo.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .YPWhite
        
        button.tintColor = .YPWhite
        button.layer.cornerRadius = 16
        button.setTitleColor(.YPBlack, for: .normal)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonEntrance), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            auth_screen_logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            auth_screen_logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 343),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func buttonEntrance() {
         performSegue(withIdentifier: "ShowWebView", sender: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
         //
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}

/*
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == ShowSingleImageSegueIdentifier {
         let viewController = segue.destination as! SingleImageViewController
         let indexPath = sender as! IndexPath
         let image = UIImage(named: photosName[indexPath.row])
         viewController.image = image
     } else {
         super.prepare(for: segue, sender: sender)
     }
 }
 */
