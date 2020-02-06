//
//  PopViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/19.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

protocol PopViewDelegate: AnyObject {
    func click()
}

class PopViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: PopViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @IBAction func click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        self.delegate?.click()
    }

}

extension PopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension PopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
