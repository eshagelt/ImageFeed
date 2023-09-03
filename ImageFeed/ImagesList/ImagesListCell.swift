//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Анастасия on 30.08.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    func configCell(with photo: String, with indexPath: IndexPath) {
        guard let image = UIImage(named: photo) else {
            return
        }
        
        cellImage.image = image
        dateLabel.text = Date().dateTimeString
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}


