//
//  CTPlayerGestureRecieverView.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CTPlayerGestureRecieverView: UIView {

    /// CTPlayerGestureRecieverViewDelegate instance
    weak var delegate: CTPlayerGestureRecieverViewDelegate? = nil
    
    /// Single tap UITapGestureRecognizer
    var tapGesture: UITapGestureRecognizer? = nil
    
    /// Double tap UITapGestureRecognizer
    var doubleTapGesture: UITapGestureRecognizer? = nil
    
    /// UIPanGestureRecognizer
    var panGesture: UIPanGestureRecognizer? = nil
    
    /// UIPinchGestureRecognizer
    var pinchGesture: UIPinchGestureRecognizer? = nil
    
    /// Whether or not reciever view is ready
    var ready: Bool = false
    
    /// Pan gesture initial point
    var panGestureInitialPoint: CGPoint = CGPoint.zero
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
        if !ready {
            prepare()
        }
    }
    
    /// Prepare the view gesture recognizers
    func prepare() {
        ready = true
        isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(with:)))
        tapGesture?.numberOfTapsRequired = 1
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(with:)))
        doubleTapGesture?.numberOfTapsRequired = 2
        
        tapGesture?.require(toFail: doubleTapGesture!)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(with:)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler(with:)))
        panGesture?.minimumNumberOfTouches = 1
        
        addGestureRecognizer(tapGesture!)
        addGestureRecognizer(doubleTapGesture!)
        addGestureRecognizer(panGesture!)
        addGestureRecognizer(pinchGesture!)
    }
    
    @objc func tapHandler(with sender: UITapGestureRecognizer) {
        delegate?.didTap(at: sender.location(in: self))
    }
    
    @objc func doubleTapHandler(with sender: UITapGestureRecognizer) {
        delegate?.didDoubleTap(at: sender.location(in: self))
    }
    
    @objc func pinchHandler(with sender: UIPinchGestureRecognizer) {
        if sender.state == .ended {
            delegate?.didPinch(with: sender.scale)
        }
    }
    
    @objc func panHandler(with sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            panGestureInitialPoint = sender.location(in: self)
        }
        delegate?.didPan(with: sender.translation(in: self), initially: panGestureInitialPoint)
    }

}
