//
//  Layer.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/10/1.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Layer: UIViewController {
    
    enum PanDirections: Int {
        case Right
        case Left
        case Bottom
        case Top
        case TopLeftToBottomRight
        case TopRightToBottomLeft
        case BottomLeftToTopRight
        case BottomRightToTopLeft
    }

    @IBOutlet weak var contentView: UIView!
    
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    
    var panDirection: PanDirections!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gestureRecognizer:)))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
        let twoFingerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerTapGesture(gestureRecognizer:)))
        twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2
        contentView.addGestureRecognizer(twoFingerTapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(gestureRecognizer:)))
        contentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setRadius()
        self.setShadow()
        self.setBorder()
        self.createColorSets()
        self.createGradientLayer()
    }
    
    func setRadius() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.contentView.layer.cornerRadius = 20
        }, completion: nil)
        
        contentView.clipsToBounds = true
        
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setShadow() {
        contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
        contentView.layer.shadowOpacity = 0.7
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    }
    
    func setBorder() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 3
    }
    
    func createColorSets() {
        colorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor])
        colorSets.append([UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorSets.append([UIColor.gray.cgColor, UIColor.lightGray.cgColor])
     
        currentColorSet = 0
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = 5
     
        gradientLayer.colors = colorSets[currentColorSet]
     
        contentView.layer.addSublayer(gradientLayer)
    }
    
    @objc func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        if currentColorSet < colorSets.count - 1 {
            currentColorSet! += 1
        }
        else {
            currentColorSet = 0
        }
     
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.toValue = colorSets[currentColorSet]
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorChangeAnimation.isRemovedOnCompletion = false
        colorChangeAnimation.delegate = self
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
    
    @objc func handleTwoFingerTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        let secondColorLocation = arc4random_uniform(100)
        let firstColorLocation = arc4random_uniform(secondColorLocation - 1)
     
        gradientLayer.locations = [NSNumber(value: Double(firstColorLocation)/100.0), NSNumber(value: Double(secondColorLocation)/100.0)]
     
        print(gradientLayer.locations!)
    }
    
    @objc func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        let velocity = gestureRecognizer.velocity(in: self.view)
     
        if gestureRecognizer.state == UIGestureRecognizer.State.changed {
            if velocity.x > 300.0 {
                // 方向朝右的例子
                // 以下是垂直移動手勢的具體實例
     
                if velocity.y > 300.0 {
                    // 由左上移動至右下
                    panDirection = PanDirections.TopLeftToBottomRight
                }
                else if velocity.y < -300.0 {
                    // 由左下移動至右上
                    panDirection = PanDirections.BottomLeftToTopRight
                }
                else {
                    // 朝右移動
                    panDirection = PanDirections.Right
                }
            }
            else if velocity.x < -300.0 {
                // 方向朝左的例子
                // 以下是垂直移動手勢的具體實例
     
                if velocity.y > 300.0 {
                    // 由右上移動至左下
                    panDirection = PanDirections.TopRightToBottomLeft
                }
                else if velocity.y < -300.0 {
                    // 由右下移動至左上
                    panDirection = PanDirections.BottomRightToTopLeft
                }
                else {
                    // 朝左移動
                    panDirection = PanDirections.Left
                }
            }
            else {
                // 垂直移動例子（朝上或朝下）
     
                if velocity.y > 300.0 {
                    // 朝下移動
                    panDirection = PanDirections.Bottom
                }
                else if velocity.y < -300.0 {
                    // 朝上移動
                    panDirection = PanDirections.Top
                }
                else {
                    // 沒有移動
                    panDirection = nil
                }
            }
        }
        else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            changeGradientDirection()
        }
    }
    
    func changeGradientDirection() {
        if panDirection != nil {
            switch panDirection.rawValue {
            case PanDirections.Right.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
     
            case PanDirections.Left.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
     
            case PanDirections.Bottom.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
     
            case PanDirections.Top.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
     
            case PanDirections.TopLeftToBottomRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
     
            case PanDirections.TopRightToBottomLeft.rawValue:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
     
            case PanDirections.BottomLeftToTopRight.rawValue:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
     
            default:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
        }
    }

}

extension Layer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = colorSets[currentColorSet]
        }
    }
}
