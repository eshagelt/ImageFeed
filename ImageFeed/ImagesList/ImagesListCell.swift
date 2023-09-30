//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Анастасия on 30.08.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView?
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    func configCell(image: UIImage, date: String, isLiked: Bool) {
        
        cellImage?.image = image
        backgroundColor = UIColor(named: "YP Black")
        dateLabel.text = Date().dateTimeString
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
    


