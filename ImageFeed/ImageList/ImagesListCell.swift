//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 29.01.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewCell.kf.cancelDownloadTask()
    }
}
