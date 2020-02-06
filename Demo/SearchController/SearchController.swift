//
//  SearchController.swift
//  test
//
//  Created by Tony Huang (黃崇漢) on 2018/4/12.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var searchController: UISearchController!
    
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblSearchResults.dataSource = self
        self.tblSearchResults.delegate = self
        
        self.loadListOfCountries()
        self.configureSearchController()
    }
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = Bundle.main.path(forResource: "countries", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            var countriesString = ""
            do {
                try countriesString = String(contentsOfFile: path, encoding: .utf8)
            } catch {}
            
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            self.dataArray = countriesString.components(separatedBy: "\n")
            
            // Reload the tableview.
            self.tblSearchResults.reloadData()
        }
    }
    
    func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.placeholder = "Search here..."
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        
        self.tblSearchResults.tableHeaderView = searchController.searchBar
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shouldShowSearchResults {
            return self.filteredArray.count
        }
        else {
            return self.dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        } else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
}

extension SearchController: UITableViewDelegate {
    
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        self.filteredArray = self.dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            
            return (countryText.range(of: searchString, options: .caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.shouldShowSearchResults = true
        self.tblSearchResults.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.shouldShowSearchResults = false
        self.tblSearchResults.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.shouldShowSearchResults = false
        self.tblSearchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !self.shouldShowSearchResults {
            self.shouldShowSearchResults = true
            self.tblSearchResults.reloadData()
        }
        
        self.searchController.searchBar.resignFirstResponder()
    }
}
