//
//  ProtocolOrientedProgramming.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/11/21.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

protocol ViewWithBorder {
    var borderColor: UIColor { get }
    var borderThickness: CGFloat { get }
    init(borderColor: UIColor, borderThickness: CGFloat, frame: CGRect)
}
 
extension ViewWithBorder where Self : UIView {
    func addBorder() -> Void {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderThickness
    }
}
 
class UIViewWithBorder : UIView, ViewWithBorder {
    let borderColor: UIColor
    let borderThickness: CGFloat
    
    // This initializer is required by UIView.
    required init(borderColor: UIColor, borderThickness: CGFloat, frame: CGRect) {
        self.borderColor = borderColor
        self.borderThickness = borderThickness
        super.init(frame: frame)
    }
    
    // This initializer is required by UIView.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ViewWithBackground {
    var customBackgroundColor: UIColor { get }
}
 
extension ViewWithBackground where Self : UIView {
    func addBackgroundColor() -> Void {
        backgroundColor = customBackgroundColor
    }
}
 
class UIViewWithBackground : UIView, ViewWithBackground {
    let customBackgroundColor: UIColor = .blue
}

protocol ViewWithBackgroundAndBorder: ViewWithBackground, ViewWithBorder {
    
}

class UIViewWithBackgroundAndBorder: UIView, ViewWithBackgroundAndBorder {
    let customBackgroundColor: UIColor = .yellow
    
    var borderColor: UIColor
    
    var borderThickness: CGFloat
    
    required init(borderColor: UIColor, borderThickness: CGFloat, frame: CGRect) {
        self.borderColor = borderColor
        self.borderThickness = borderThickness
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProtocolOrientedProgramming: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addViewButtonTapped(_ sender: Any) {
        let customFrame1 = CGRect(x: 110, y: 210, width: 100, height: 100)
        let customView1 = UIViewWithBackground(frame: customFrame1)
        customView1.addBackgroundColor()
        self.view.addSubview(customView1)
        
        let customFrame2 = CGRect(x: 110, y: 320, width: 100, height: 100)
        let customView2 = UIViewWithBorder(borderColor: .red, borderThickness: 10.0, frame: customFrame2)
        customView2.addBorder()
        self.view.addSubview(customView2)
        
        let customFrame3 = CGRect(x: 110, y: 430, width: 100, height: 100)
        let customView3 = UIViewWithBackgroundAndBorder(borderColor: .green, borderThickness: 10.0, frame: customFrame3)
        customView3.addBackgroundColor()
        customView3.addBorder()
        self.view.addSubview(customView3)
    }
}
