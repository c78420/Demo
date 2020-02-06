//
//  SideMenu.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/5/8.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class SideMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTabBar") {
            self.present(vc, animated: true, completion: nil)
        }
    }

}
