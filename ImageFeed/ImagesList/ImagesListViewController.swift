//
//  ViewController.swift
//  ImageFeed
//
//  Created by Анастасия on 27.08.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func viewDidLoad()
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListViewPresenterProtocol? = {
        return ImagesListViewPresenter()
    }()
    
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    private let dateFormatter = CustomDateFormatters.shared.dateFormatter
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        configureNotificationObserver()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = .ypBackground

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            let indexPath = sender as? IndexPath
            guard let viewController = viewController,
                  let indexPath = indexPath else {
                return
            }
            let photo = photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL) else { return }
            viewController.imageURL = imageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
            let oldCount = photos.count
            guard let newCount = presenter?.imagesListService.photos.count else { return }
            guard let newPhotos = presenter?.imagesListService.photos else { return}
            photos = newPhotos
            
            if oldCount != newCount {
                tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    
    func configureNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
}

extension ImagesListViewController {
    private func configCell (for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageURL = photos[indexPath.row].thumbImageURL
        let url = URL(string: imageURL)
        let placeholder = UIImage(named: "LoaderImage")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        
        if let date = imagesListService.photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date as Date).replacingOccurrences(of: "r.", with: "")
        }
        
        let isLiked = imagesListService.photos[indexPath.row].isLiked == false
        let likeImage = isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = photos[indexPath.row]
        let imageSize = CGSize(width: cell.width, height: cell.height)
        let aspectRatio = imageSize.width / imageSize.height
        return tableView.frame.width / aspectRatio
    }
}

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
        imageListCell.likeButton.accessibilityIdentifier = "like button"
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let photo = photos[indexPath.row]
            UIBlockingProgressHUD.show()
            imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
                DispatchQueue.main.async {
                    switch result {
                    case.success:
                        self.photos = self.imagesListService.photos
                        cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                        UIBlockingProgressHUD.dismiss()
                    case.failure(let error):
                        UIBlockingProgressHUD.dismiss()
                        self.showLikeErrorAlert(with: error)
                    }
                }
            }
        }
    
    func showLikeErrorAlert(with error: Error) {
            let alert = UIAlertController(
                title: "Что-то пошло не так(",
                message: "Не удалось поставить лайк",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
}
