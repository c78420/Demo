//
//  ExampleII.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/19.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ExampleII: UIViewController {
    
    var alertView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createView()
    }
    
    func createView() {
        
        //建立一個紅色視圖
        let alertWidth: CGFloat = view.bounds.width
        let alertHeight: CGFloat = view.bounds.height
        let alertViewFrame: CGRect = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.red
        
        //建立一個圖像視圖並加入至這個視圖
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight/2))
        imageView.image = UIImage(named: "header_bg")
        alertView.addSubview(imageView)
        
        //建立一個按鈕，並為按鈕被按下的動作來設定一個監聽者（listener）。然後這按鈕被加到alert view上。
        let button = UIButton(type: .system) as UIButton
        button.setTitle("Dismiss", for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        let buttonWidth: CGFloat = alertWidth/2
        let buttonHeight: CGFloat = 40
        button.frame = CGRect(x: alertView.center.x - buttonWidth/2, y: alertView.center.y - buttonHeight/2, width: buttonWidth, height: buttonHeight)
        
        button.addTarget(self, action: #selector(dismissAlert), for: UIControl.Event.touchUpInside)
        
        alertView.addSubview(button)
        view.addSubview(alertView)
    }
    
    @objc func dismissAlert() {
        guard let snapshot = alertView.snapshotView(afterScreenUpdates: false) else { return }
        snapshot.frame = alertView.frame
        view.addSubview(snapshot)
        alertView.removeFromSuperview()
        
        let bounds = alertView.bounds
        let smallFrame = alertView.frame.insetBy(dx: alertView.frame.size.width / 4, dy: alertView.frame.size.height / 4)
        let finalFrame = smallFrame.offsetBy(dx: 0, dy: bounds.size.height)
        
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                snapshot.frame = smallFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                snapshot.frame = finalFrame
            }
        }, completion: nil)
    }

}
