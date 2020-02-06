//
//  MovieDetailsViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/26.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imgMovieImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    var movieData: MoviesData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateMovieInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblRating.layer.cornerRadius = lblRating.frame.size.width/2
        lblRating.layer.masksToBounds = true
    }
    
    func populateMovieInfo() {
        lblTitle.text = movieData.Title
        lblCategory.text = movieData.Category
        lblDescription.text = movieData.Description
        lblDirector.text = movieData.Director
        lblStars.text = movieData.Stars
        lblRating.text = movieData.Rating
        imgMovieImage.image = UIImage(named: movieData.Image)
    }

}
