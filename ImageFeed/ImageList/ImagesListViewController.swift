//
//  ViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 22.01.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification,
                                                                          object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
    
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
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let url = URL(string: photos[tableView.index(ofAccessibilityElement: indexPath)].thumbImageURL) else { return }
        cell.imageViewCell.kf.setImage(with: url, placeholder: UIImage(named: "zaglushka.png"), completionHandler: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        cell.imageViewCell.kf.indicatorType = .activity
//        guard let imageCell = UIImage(named: photosName[indexPath.row]) else {
//            return
//        }
//        cell.imageViewCell.image = imageCell
        cell.dateTextLabel.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

//extension ImagesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photosName.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
//
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        configCell(for: imageListCell, with: indexPath)
//        return imageListCell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
//            imagesListService.fetchPhotosNextPage()
//        }
//
//    }
//}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
            imagesListService.fetchPhotosNextPage()
        }

    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

