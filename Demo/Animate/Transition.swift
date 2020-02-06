//
//  Transition.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/16.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Transition: UIViewController {
    
    @IBOutlet weak var speedDescription: UILabel!
    @IBOutlet weak var effect1: UISegmentedControl!
    @IBOutlet weak var effect2: UISegmentedControl!
    @IBOutlet weak var effectDescription: UILabel!
    
    var containerView: UIView?
    var containerView2: UIView?
    var isReverseNeeded = true
    
    var speed = UIView.AnimationOptions.curveLinear
    var effect = UIView.AnimationOptions.transitionFlipFromLeft

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.containerView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        if let view = self.containerView {
            view.backgroundColor = .blue
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 20
            view.center = self.view.center
            
            self.view.addSubview(view)
        }
        
        self.containerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        if let view = self.containerView2 {
            view.backgroundColor = .green
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 20
            view.center = self.view.center
        }
        
        self.speedClick(UISegmentedControl())
        self.effect1Click(UISegmentedControl())
    }

    @IBAction func speedClick(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case -1, 0:
            self.speed = .curveLinear
            self.speedDescription.text = "動畫勻速執行，預設值"
        case 1:
            self.speed = .curveEaseInOut
            self.speedDescription.text = "動畫先緩慢，然後逐漸加速"
        case 2:
            self.speed = .curveEaseIn
            self.speedDescription.text = "動畫逐漸變慢"
        case 3:
            self.speed = .curveEaseOut
            self.speedDescription.text = "動畫逐漸加速"
        default:
            break
        }
    }
    
    @IBAction func effect1Click(_ sender: UISegmentedControl) {
        self.effect2.selectedSegmentIndex = UISegmentedControl.noSegment
        
        switch sender.selectedSegmentIndex {
        case -1, 0:
            self.effect = .transitionFlipFromLeft
            self.effectDescription.text = "從左側翻轉效果"
        case 1:
            self.effect = .transitionFlipFromRight
            self.effectDescription.text = "從右側翻轉效果"
        case 2:
            self.effect = .transitionCurlUp
            self.effectDescription.text = "向後翻頁效果"
        case 3:
            self.effect = .transitionCurlDown
            self.effectDescription.text = "向前翻頁效果"
        default:
            break
        }
    }
    
    @IBAction func effect2Click(_ sender: UISegmentedControl) {
        self.effect1.selectedSegmentIndex = UISegmentedControl.noSegment
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.effect = .transitionCrossDissolve
            self.effectDescription.text = "淡入淡出"
        case 1:
            self.effect = .transitionFlipFromTop
            self.effectDescription.text = "從上方翻轉效果"
        case 2:
            self.effect = .transitionFlipFromBottom
            self.effectDescription.text = "從下方翻轉效果"
        default:
            break
        }
    }
    
    @IBAction func doTransition(_ sender: Any) {
        let duration = 0.5
        
        guard let view1 = self.containerView, let view2 = self.containerView2 else {
            return
        }
        
        UIView.transition(from: self.isReverseNeeded ? view1 : view2, to: self.isReverseNeeded ? view2 : view1, duration: duration, options: [self.speed, self.effect]) { (complete) in
            self.isReverseNeeded = !self.isReverseNeeded
        }
    }
}
