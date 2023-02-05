//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 03.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileContact: UILabel!
    @IBOutlet weak var profileAbout: UILabel!
    
    @IBAction func logOut(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
