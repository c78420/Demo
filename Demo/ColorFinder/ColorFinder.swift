//
//  ColorFinder.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/13.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

enum ColorSlider: Int {
    case red = 1
    case green
    case blue
}

class ColorFinder: UIViewController {
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBAction func colorChange(_ sender: UISlider) {
        var color = (red: CGFloat(1.0), greed: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
        
        if let components = self.view.backgroundColor?.cgColor.components {
            if components.count < 4 {
                color.red = components[0]
                color.greed = components[0]
                color.blue = components[0]
                color.alpha = components[1]
            }
            else {
                color.red = components[0]
                color.greed = components[1]
                color.blue = components[2]
                color.alpha = components[3]
            }
        }
        
        switch sender.tag {
        case ColorSlider.red.rawValue:
            color.red = CGFloat(sender.value / 255.0)
            self.redLabel.text = "\(Int(sender.value))"
            break
        case ColorSlider.green.rawValue:
            color.greed = CGFloat(sender.value / 255.0)
            self.greenLabel.text = "\(Int(sender.value))"
            break
        case ColorSlider.blue.rawValue:
            color.blue = CGFloat(sender.value / 255.0)
            self.blueLabel.text = "\(Int(sender.value))"
            break
        default:
            break
        }
        
        self.view.backgroundColor = UIColor(red: color.red, green: color.greed, blue: color.blue, alpha: color.alpha)
    }
}
