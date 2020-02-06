//
//  ContentViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var nowPageNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: "\(self.nowPageNumber)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
