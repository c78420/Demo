//
//  DetailViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/21.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var imageView: UIImageView!
    
    //
    // MARK: Variables And Properties
    //
    /// The URL of image
    var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrl = imageUrl {
            imageView.kf.setImage(with: URL(string: imageUrl))
        }
    }

}
