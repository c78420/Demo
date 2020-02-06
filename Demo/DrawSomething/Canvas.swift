//
//  Canvas.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/14.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Canvas: UIView {

    var lineColor = UIColor.white
    var lineWidth: CGFloat = 10
    var path: UIBezierPath?
    var touchPoint: CGPoint?
    var staringPoint: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.staringPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint = touches.first?.location(in: self)
        self.path = UIBezierPath()
        if let star = self.staringPoint, let touch = self.touchPoint {
            self.path?.move(to: star)
            self.path?.addLine(to: touch)
            self.staringPoint = self.touchPoint
            self.draw()
        }
    }
    
    func draw() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.path?.cgPath
        shapeLayer.strokeColor = self.lineColor.cgColor
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }

    func clearCanvas() {
        self.path?.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
}
