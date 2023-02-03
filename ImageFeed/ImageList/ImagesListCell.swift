//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 29.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
}
