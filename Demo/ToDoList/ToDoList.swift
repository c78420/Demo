//
//  ToDoList.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/19.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ToDoList: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var toDos: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: "toDos")
            self.myTableView.reloadData()
        }
        get {
            return UserDefaults.standard.stringArray(forKey: "toDos")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.myTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ToDoList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let toDos = self.toDos {
            return toDos.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.toDos?[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "arial", size: 24)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.toDos?.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let vc = self.tabBarController?.viewControllers?[1] as? ToDoListAdd {
            vc.infoFromViewOne = indexPath.row
            self.tabBarController?.selectedIndex = 1
        }
    }
}

extension ToDoList: UITableViewDelegate {
    
}
