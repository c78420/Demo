//
//  FirstViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/14.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var firstTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMe(_ segue: UIStoryboardSegue) {
        if let vc = segue.source as? SecondViewController {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
