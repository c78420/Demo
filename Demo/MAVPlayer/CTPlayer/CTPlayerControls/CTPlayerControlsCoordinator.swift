//
//  CTPlayerControlsCoordinator.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class CTPlayerControlsCoordinator: UIView {

    /// CTPlayerView instance being used
    weak var player: CTPlayerView!
    
    /// CTPlayerControls instance being used
    var controls: (UIView & CTPlayerPlaybackDelegate)!
    
    /// CTPlayerGestureRecieverView instance being used
    var gestureReciever: CTPlayerGestureRecieverView!
    
    /// CTPlayerControlsBehaviour being used to validate ui
    var behaviour: CTPlayerControlsBehaviour!

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stretchToEdges()
    }
    
    func configureView() {
        if let h = superview as? CTPlayerView {
            player = h
            if controls != nil {
                if behaviour == nil {
                    behaviour = CTPlayerControlsBehaviour(with: controls)
                    behaviour.handler = player
                }
                
                addSubview(controls)
            }
            if gestureReciever == nil {
                gestureReciever = CTPlayerGestureRecieverView()
                gestureReciever.delegate = self
                addSubview(gestureReciever)
                sendSubviewToBack(gestureReciever)
            }
            stretchToEdges()
        }
    }
    
    func stretchToEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
}

extension CTPlayerControlsCoordinator: CTPlayerGestureRecieverViewDelegate {

    /// Notifies when pinch was recognized
    func didPinch(with scale: CGFloat) {
        
    }
    
    /// Notifies when tap was recognized
    func didTap(at point: CGPoint) {
        if behaviour.showingControls {
            behaviour.hide()
        }
        else {
            behaviour.show()
        }
    }
    
    /// Notifies when tap was recognized
    func didDoubleTap(at point: CGPoint) {
        
    }
    
    /// Notifies when pan was recognized
    func didPan(with translation: CGPoint, initially at: CGPoint) {
        
    }
}
