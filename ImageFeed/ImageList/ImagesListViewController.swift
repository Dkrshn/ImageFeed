//
//  ViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 22.01.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
  //  private let photosName: [String] = Array(0..<20).map{ "\($0)" }
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
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            //let image = UIImage(named: photosName[indexPath.row])
            let image = UIImageView()
            guard let url = URL(string: photos[indexPath.row].largeImageURL) else { return }

            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }
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
//        if indexPath.row % 2 == 0 {
//            cell.likeButton.setImage(UIImage(named: "Active"), for: .normal)
//        } else {
//            cell.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
//        }
        if photos[indexPath.row].isLiked {
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
        imageListCell.delegate = self
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
        
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        //UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, {[weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(_):
                self.photos = self.imagesListService.photos
                self.setLike(cell, index: indexPath.row)
                //UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                //UIBlockingProgressHUD.dismiss()
                print(error.localizedDescription)
            }
        })
    }
    
    func setLike(_ cell: ImagesListCell, index: Int) {
        if photos[index].isLiked {
            cell.likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
}

extension ImagesListViewController {
    private func showError() {
        let alert = UIAlertController(title: nil, message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let dissmissAction = UIAlertAction(title: "Не надо", style: .default) {_ in
            alert.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) {[weak self] _ in
            guard let self = self else { return }
            
        }
    }
}
