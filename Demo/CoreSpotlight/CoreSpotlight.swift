//
//  CoreSpotlight.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/26.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

struct MoviesData: Codable {
    var Title: String
    var Category: String
    var Rating: String
    var Description: String
    var Director: String
    var Stars: String
    var Image: String
}

class CoreSpotlight: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movieDatas: [MoviesData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MovieSummaryCell", bundle: nil), forCellReuseIdentifier: "idCellMovieSummary")
        
        self.loadMovieDatas()
        
        self.setupSearchableContent()
    }
    
    func loadMovieDatas() {
        if let path = Bundle.main.path(forResource: "MoviesData", ofType: "plist") {
            let fileUrl = URL(fileURLWithPath: path)
            
            guard let codedMoviesData = try? Data(contentsOf: fileUrl) else { return }
            let decoder = PropertyListDecoder()
            
            self.movieDatas = try? decoder.decode([MoviesData].self, from: codedMoviesData)
            
            self.tableView.reloadData()
        }
    }
    
    func setupSearchableContent() {
        var searchableItems = [CSSearchableItem]()
        
        for (index, data) in movieDatas.enumerated() {
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            
            // Set the title.
            searchableItemAttributeSet.title = data.Title
            
            // Set the movie image.
            let imagePathParts = data.Image.components(separatedBy: ".")
            searchableItemAttributeSet.thumbnailURL = Bundle.main.url(forResource: imagePathParts[0], withExtension: imagePathParts[1])
            
            // Set the description.
            searchableItemAttributeSet.contentDescription = data.Description
            
            var keywords = [String]()
            let movieCategories = data.Category.components(separatedBy: ", ")
            for movieCategory in movieCategories {
                keywords.append(movieCategory)
            }
            
            let stars = data.Stars.components(separatedBy: ", ")
            for star in stars {
                keywords.append(star)
            }
            
            searchableItemAttributeSet.keywords = keywords
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.my.demo.project.\(index)", domainIdentifier: "movies", attributeSet: searchableItemAttributeSet)
            
            searchableItems.append(searchableItem)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType {
            if let userInfo = activity.userInfo {
                let selectedMovie = userInfo[CSSearchableItemActivityIdentifier] as! String
                let selectedMovieIndex = Int((selectedMovie.components(separatedBy: ".")).last!)
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                vc.movieData = self.movieDatas[selectedMovieIndex!]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}

extension CoreSpotlight: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellMovieSummary", for: indexPath) as! MovieSummaryCell

        let currentMovieInfo = self.movieDatas[indexPath.row]

        cell.lblTitle.text = currentMovieInfo.Title
        cell.lblDescription.text = currentMovieInfo.Description
        cell.lblRating.text = currentMovieInfo.Rating
        cell.imgMovieImage.image = UIImage(named:currentMovieInfo.Image)

        return cell
    }
}

extension CoreSpotlight: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movieData = self.movieDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
