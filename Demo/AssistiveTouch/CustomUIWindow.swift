//
//  CustomUIWindow.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/23.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CustomUIWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.contents = UIImage(named: "ball1")?.cgImage
        windowLevel = UIWindow.Level.alert + 1
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        pan.delaysTouchesBegan = true
        addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePanGesture(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: UIApplication.shared.windows[0])
        let originalCenter = center
        center = CGPoint(x:originalCenter.x + translation.x, y:originalCenter.y + translation.y)
        pan.setTranslation(CGPoint.zero, in: UIApplication.shared.windows[0])
    }

}
