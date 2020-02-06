//
//  ShapeFactory.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/11/21.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

// these values have been pre-selected by
// the graphics and design teams
let defaultHeight = 200
let defaultColor = UIColor.blue
 
protocol HelperViewFactoryProtocol {
    func configure()
    func position()
    func display()
    var height: Int { get }
    var view: DisplayView { get }
    var parentView: UIView { get }
}

extension HelperViewFactoryProtocol {
    func position() {
        view.center = parentView.center
    }
    
    func display() {
        configure()
        position()
        parentView.addSubview(view)
    }
}

fileprivate class Square: HelperViewFactoryProtocol {
    
    let height: Int
    let parentView: UIView
    var view: DisplayView
    
    init(height: Int = defaultHeight, parentView: UIView) {
        self.height = height
        self.parentView = parentView
        view = DisplayView()
    }
    
    func configure() {
        let frame = CGRect(x: 0, y: 0, width: height, height: height)
        view.frame = frame
        view.backgroundColor = defaultColor
    }
} // end class Square

fileprivate class Circle : HelperViewFactoryProtocol {
    
    let height: Int
    let parentView: UIView
    var view: DisplayView
    
    init(height: Int = defaultHeight, parentView: UIView) {
        self.height = height
        self.parentView = parentView
        view = DisplayView()
    }
    
    func configure() {
        let frame = CGRect(x: 0, y: 0, width: height, height: height)
        view.frame = frame
        view.backgroundColor = defaultColor
        
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = true
    }
    
} // end class Circle

fileprivate class Rectangle : HelperViewFactoryProtocol {
    
    let height: Int
    let parentView: UIView
    var view: DisplayView
    
    init(height: Int = defaultHeight, parentView: UIView) {
        self.height = height
        self.parentView = parentView
        view = DisplayView()
    }
    
    func configure() {
        let frame = CGRect(x: 0, y: 0, width: height + height/2, height: height)
        view.frame = frame
        view.backgroundColor = UIColor.blue
    }
    
} // end class Rectangle

class DisplayView: UIView {
    
}

enum Shapes {
    case square
    case circle
    case rectangle
}
 
class ShapeFactoryClass {
    
    let parentView: UIView
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    func create(as shape: Shapes) -> HelperViewFactoryProtocol {
        
        switch shape {
        case .square:
            let square = Square(parentView: parentView)
            return square
        case .circle:
            let circle = Circle(parentView: parentView)
            return circle
        case .rectangle:
            let rectangle = Rectangle(parentView: parentView)
            return rectangle
        }
        
    } // end func display
    
} // end class ShapeFactory
 
// Public factory method to display shapes.
func createShape(_ shape: Shapes, on view: UIView) {
    let shapeFactory = ShapeFactoryClass(parentView: view)
    shapeFactory.create(as: shape).display()
}
 
// Alternative public factory method to display shapes.
// Technically, the factory method should return one of
// a number of related classes.
func getShape(_ shape: Shapes, on view: UIView) -> HelperViewFactoryProtocol {
    let shapeFactory = ShapeFactoryClass(parentView: view)
    return shapeFactory.create(as: shape)
}

import UIKit

class ShapeFactory: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func draw(_ sender: UISegmentedControl) {
        for view in view.subviews {
            if view is DisplayView {
                view.removeFromSuperview()
            }
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            createShape(.circle, on: view)
        case 1:
            createShape(.square, on: view)
        case 2:
            let rectangle = getShape(.rectangle, on: view)
            rectangle.display()
        default:
            return
        }
    }
    
}
