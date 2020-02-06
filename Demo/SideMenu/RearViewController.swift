//
//  RearViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/5/8.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

private let reuseIdentifierRearCell = "reuseRearCell"

class RearViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func setup() {
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RearViewController.actDissmiss))
        backgroundView.addGestureRecognizer(tap)
        
        tableView.register(UINib(nibName: "RearCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierRearCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 50.0
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func actDissmiss() {
        
    }
}

extension RearViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierRearCell, for: indexPath) as? RearCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension RearViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
