//
//  MVVM.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/21.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MVVM: UIViewController {

    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var tableView: UITableView!
    
    //
    // MARK: - Created The Photo List ViewModel
    //
    /// Use the keyword "lazy" to wait for view model to be created.
    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel()
    }()
    
    //
    // MARK: - View Controller's life cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the static view.
        initView()
        
        // Initialize view model.
        initVM()
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
    
    // Init view model
    func initVM() {
        // Naive  binding
        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        self.viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        self.viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.viewModel.initFetch()
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
extension MVVM: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.registerID, for: indexPath) as? PhotoListTableViewCell {
            cell.configureCell(photo: self.viewModel.getCellViewModel(at: indexPath))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.viewModel.userPressed(at: indexPath)
        if self.viewModel.isAllowSegue {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.imageUrl = self.viewModel.selectedPhoto?.image_url
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
