//
//  Lottie.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/5.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Lottie

class Lottie: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let animationView = AnimationView(name: "159-servishero-loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        view.addSubview(animationView)
        
        animationView.play()
    }

}
