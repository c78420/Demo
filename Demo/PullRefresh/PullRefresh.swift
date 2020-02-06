//
//  PullRefresh.swift
//  test
//
//  Created by Tony Huang (黃崇漢) on 2018/4/11.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class PullRefresh: UIViewController {
    @IBOutlet weak var customView: UIView!
    var labelsArray: Array<UILabel> = []
    
    // 指示自訂動畫是否正在進行中。
    var isAnimating = false
    // 指示應該被套用到下一個標籤的合適顏色。
    var currentColorIndex = 0
    // 指示的是正在進行第 1 部分動畫的標籤索引。
    var currentLabelIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for tag in 0..<self.customView.subviews.count {
            self.labelsArray.append(self.customView.viewWithTag(tag+1) as! UILabel)
        }
    }
    
    @IBAction func Start(_ sender: Any) {
        if !self.isAnimating {
            self.animateRefreshStep1()
        }
    }
    
    // 旋轉並將其文字變色
    func animateRefreshStep1() {
        self.isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: .pi/4)
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
        }, completion: { (finished) -> Void in
            
            UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                self.labelsArray[self.currentLabelIndex].transform = .identity
                self.labelsArray[self.currentLabelIndex].textColor = .black
                
            }, completion: { (finished) -> Void in
                self.currentLabelIndex = self.currentLabelIndex + 1
                
                if self.currentLabelIndex < self.labelsArray.count {
                    self.animateRefreshStep1()
                }
                else {
                    self.animateRefreshStep2()
                }
            })
        })
    }
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                self.labelsArray[0].transform = .identity
                self.labelsArray[1].transform = .identity
                self.labelsArray[2].transform = .identity
                self.labelsArray[3].transform = .identity
                
            }, completion: { (finished) -> Void in
                self.isAnimating = false
                self.currentLabelIndex = 0
                for label in self.labelsArray {
                    label.textColor = .black
                    label.transform = .identity
                }
            })
        })
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [.magenta, .brown, .yellow, .red, .green, .blue, .orange]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        self.currentLabelIndex = self.currentLabelIndex + 1
        
        return returnColor
    }
}
