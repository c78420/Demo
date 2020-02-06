//
//  TransparentNavigation.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/13.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class TransparentNavigation: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage()
        
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
    }

}
