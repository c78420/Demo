//
//  PhotoListTableViewCell.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/21.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Kingfisher

class PhotoListTableViewCell: UITableViewCell {
    
    static var registerID = "PhotoListTableViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(photo: Photo) {
        // Text
        nameLabel.text = photo.name
        // Wrap a description
        var descText: [String] = [String]()
        if let camera = photo.camera {
            descText.append(camera)
        }
        
        if let description = photo.description {
            descText.append(description)
        }
        
        descriptionLabel.text = descText.joined(separator: " - ")
        
        // Wrap the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: photo.created_at)
        
        // Image
        mainImageView.kf.setImage(with: URL(string: photo.image_url))
    }
    
    func configureCell(photo: PhotoListCellViewModel) {
        nameLabel.text = photo.titleText
        descriptionLabel.text = photo.descText
        mainImageView.kf.setImage(with: URL(string: photo.imageUrl))
        dateLabel.text = photo.dateText
    }
    
}
