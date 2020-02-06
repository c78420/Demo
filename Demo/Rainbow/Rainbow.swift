//
//  Rainbow.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/15.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit


class Rainbow: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

@IBDesignable
class RainbowView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor(red: (37.0/255.0), green: (252.0/255), blue: (244.0/255.0), alpha: 1.0)
    @IBInspectable var secondColor: UIColor = UIColor(red: (171.0/255.0), green: (250.0/255), blue: (81.0/255.0), alpha: 1.0)
    @IBInspectable var thirdColor: UIColor = UIColor(red: (238.0/255.0), green: (32.0/255), blue: (53.0/255.0), alpha: 1.0)
    @IBInspectable var firstDiameter: CGFloat = 80
    @IBInspectable var secondDiameter: CGFloat = 150
    @IBInspectable var thirdDiameter: CGFloat = 215
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        // Add ARCs
        self.addCirle(arcRadius: self.firstDiameter, capRadius: 20, color: self.firstColor)
        self.addCirle(arcRadius: self.secondDiameter, capRadius: 20, color: self.secondColor)
        self.addCirle(arcRadius: self.thirdDiameter, capRadius: 20, color: self.thirdColor)
    }
    
    func addCirle(arcRadius: CGFloat, capRadius: CGFloat, color: UIColor) {
        let X = self.bounds.midX
        let Y = self.bounds.midY
        
        // Bottom Oval
        let pathBottom = UIBezierPath(ovalIn: CGRect(x: (X - (arcRadius/2)), y: (Y - (arcRadius/2)), width: arcRadius, height: arcRadius)).cgPath
        self.addOval(lineWidth: 20.0, path: pathBottom, strokeStart: 0, strokeEnd: 1, strokeColor: color, fillColor: UIColor.clear, shadowRadius: 0, shadowOpacity: 0, shadowOffsset: .zero)
        
        // Middle Cap
        let pathMiddle = UIBezierPath(ovalIn: CGRect(x: (X - (capRadius/2)) - (arcRadius/2), y: (Y - (capRadius/2)), width: capRadius, height: capRadius)).cgPath
        self.addOval(lineWidth: 0.0, path: pathMiddle, strokeStart: 0, strokeEnd: 1.0, strokeColor: color, fillColor: color, shadowRadius: 5.0, shadowOpacity: 0.5, shadowOffsset: .zero)
    }
    
    func addOval(lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize) {
        
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
    }
    
}
