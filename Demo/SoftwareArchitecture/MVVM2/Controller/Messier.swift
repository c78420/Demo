//
//  Messier.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/22.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Messier: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // #1 - The UITableViewDataSource and
        // UITableViewDelegate protocols are
        // adopted in extensions.
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension Messier: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messierViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessierCell")
        
        // #1 - The ViewModel is the app's de facto data source.
        tableViewCell?.imageView?.image = UIImage(named: messierViewModel[indexPath.row].thumbnail)
        tableViewCell?.textLabel?.text = messierViewModel[indexPath.row].formalName
        tableViewCell?.detailTextLabel?.text = messierViewModel[indexPath.row].commonName
        
        return tableViewCell!
    }
}

extension Messier: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "MessierDetail") as? MessierDetail {
            vc.messierViewModel = messierViewModel[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
