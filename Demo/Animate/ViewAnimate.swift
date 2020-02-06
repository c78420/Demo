//
//  ViewAnimate.swift
//  test
//
//  Created by Tony Huang (黃崇漢) on 2018/4/13.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

enum Animates: String, CaseIterable {
    case Spring
    case Transition
    case ExampleI
    case ExampleII
    case PropertyAnimator
}

class ViewAnimate: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension ViewAnimate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Animates.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = Animates.allCases[indexPath.row].rawValue
        
        return cell
    }
}

extension ViewAnimate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = Animates.allCases[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: data.rawValue)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
