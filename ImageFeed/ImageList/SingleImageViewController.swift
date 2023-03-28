//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Даниил Крашенинников on 05.02.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    //    var image: UIImage! {
    //        didSet {
    //            guard isViewLoaded else { return }
    //            imageView.image = image
    //            rescaleAndCenterImageInScrollView(image: image)
    //        }
    //    }
        
        var imageURL: URL? {
            didSet {
                guard isViewLoaded else { return }
                setImage(url: imageURL)
            }
        }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 1.25
        scrollView.minimumZoomScale = 0.1
        scrollView.delegate = self
        // imageView.image = image
       // rescaleAndCenterImageInScrollView(image: image)
        setImage(url: imageURL)
    }
    
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareVC = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func setImage(url: URL?) {
        guard let url = url else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let resultImage):
                self.rescaleAndCenterImageInScrollView(image: resultImage.image)
            case .failure(_):
                break
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
        //test
    }
}
