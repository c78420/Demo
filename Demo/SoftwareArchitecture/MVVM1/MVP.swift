//
//  MVP.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/22.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MVP: UIViewController {

    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter: Presenter = {
        return Presenter(delegate: self)
    }()
    
    //
    // MARK: - View Controller's life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        presenter.initFetch()
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
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//
// MARK: - Table View Delegate & Table View Data Source
//
extension MVP: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.registerID, for: indexPath) as? PhotoListTableViewCell {
            cell.configureCell(photo: self.presenter.getCellPhoto(at: indexPath))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.presenter.userPressed(at: indexPath) {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.imageUrl = self.presenter.getCellPhoto(at: indexPath).image_url
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MVP: MVPProtocol {
    func apiOnError(message: String?) {
        DispatchQueue.main.async {
            guard let message = message else {
                return
            }
            
            self.showAlert(message)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateLoadingStatus(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 0.0
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 1.0
                })
            }
        }
    }
}
