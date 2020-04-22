//
//  MVC.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/21.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MVC: UIViewController {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var tableView: UITableView!
    
    //
    // MARK: Variables And Properties
    //
    /// Array initialization of search results.
    var photos: [Photo] = [Photo]()
    /// Record the selected "IndexPath".
    var selectedIndexPath: IndexPath?
    /// Use the keyword "lazy" to wait for APIService's results.
    lazy var apiService: APIService = {
        return APIService()
    }()
    
    //
    // MARK: - View Controller's life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // Fetch data from server
        initDate()
    }
    
    //
    // MARK: - Private Methods
    //
    // Init the static view
    func initView() {
        self.navigationItem.title = "Popular"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: PhotoListTableViewCell.registerID, bundle: nil), forCellReuseIdentifier: PhotoListTableViewCell.registerID)
    }
    
    // Fetch data from server
    func initDate() {
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            DispatchQueue.main.async {
                self?.photos = photos
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })
                
                self?.tableView.reloadData()
            }
        }
    }

}

extension MVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.registerID, for: indexPath) as? PhotoListTableViewCell {
            cell.configureCell(photo: self.photos[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let photo = self.photos[indexPath.row]
        if photo.for_sale { // If item is for sale
            self.selectedIndexPath = indexPath
            return indexPath
        } else {    // If item is not for sale
            let alert = UIAlertController(title: "Alert", message: "This item is not for sale", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.imageUrl = self.photos[indexPath.row].image_url
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
