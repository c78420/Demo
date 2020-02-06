//
//  DrawSomething.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/14.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class DrawSomething: UIViewController {

    @IBOutlet weak var canvas: Canvas!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.canvas.clipsToBounds = true
        self.canvas.isMultipleTouchEnabled = false
    }

    @IBAction func clear(_ sender: UIButton) {
        self.canvas.clearCanvas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
