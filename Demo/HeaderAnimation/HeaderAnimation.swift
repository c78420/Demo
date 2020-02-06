//
//  HeaderAnimation.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/12/9.
//  Copyright © 2018 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class HeaderAnimation: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sampleDataArray = [String]()
    var coordinateManager: CoordinateManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...20 {
            self.sampleDataArray.append(String(format: "sample %02d", i))
        }

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let headerImg = UIImage.init(named: "header_bg")
        let imgHeight = headerImg?.size.height ?? 0
        let imgWidth = headerImg?.size.width ?? 0
        let imageHeight = (imgHeight / imgWidth) * self.view.frame.width
        let headerView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageHeight))
        headerView.image = headerImg
        
        
        self.coordinateManager = CoordinateManager(scrollView: self.tableView, header: headerView)
    }

}

extension HeaderAnimation: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sampleDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.sampleDataArray[indexPath.row]
        
        return cell
    }
}

extension HeaderAnimation: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let manager = self.coordinateManager else {
            return
        }
        manager.scrolledDetection(scrollView)
    }
}
