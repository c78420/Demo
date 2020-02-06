//
//  Gif.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/15.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Gif: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = NSDataAsset(name: "cat")?.data {
            imageView.image = UIImage.gifWithData(data)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
