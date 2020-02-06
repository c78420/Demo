//
//  DropDownMenu.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/14.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class DropDownMenu: UIViewController {

    @IBOutlet var options: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for button in self.options {
            button.addTarget(self, action: #selector(self.optionPressed(_:)), for: .touchUpInside)
        }
        
        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
//        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Dropdown Menu"), items: items)
        
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(1), items: items)
        
        self.navigationItem.titleView = menuView

    }

    @IBAction func starSelect(_ sender: UIButton) {
        for button in self.options {
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func optionPressed(_ sender: UIButton) {
        for button in self.options {
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
