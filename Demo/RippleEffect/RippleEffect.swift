//
//  RippleEffect.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/7/9.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class RippleEffect: UIViewController {
    
    let FULL = 2 * Double.pi

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let tapView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        tapView.center = view.center
        tapView.backgroundColor = .yellow
        tapView.layer.cornerRadius = 100
        
        view.addSubview(tapView)
    }

    @objc func tap(_ gesture: UIGestureRecognizer) {
        
    }
    
    func addRippleEffect(to referenceView: UIView) {
        
    }
}
