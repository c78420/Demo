//
//  Spring.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/18.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Spring: UIViewController {
    
    let animateView = UIView(frame: CGRect(x: 0, y: 64, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.animateView.backgroundColor = .red
        self.view.addSubview(self.animateView)
    }

    @IBAction func springClick(_ sender: Any) {
        /*
         usingSpringWithDamping:值為0~1，是用來判斷朝向動畫端點所需要的視圖彈跳數。其值越接近1，彈跳數會越少下
         initialSpringVelocity:是判斷動畫的初始速度。倘若你想要一開始就很強勁的話，將值設定大一點，倘若你是想要平滑一點的動畫，你可以將值設為0
         */
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.animateView.frame = CGRect(x: 50, y: 250, width: 200, height: 200)
        }, completion: nil)
    }
}
