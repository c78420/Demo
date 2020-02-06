//
//  IMAControls.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/23.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class IMAControls: UIView {
    
    @IBOutlet weak var playPauseButton: IMAStatefulButton!
    @IBOutlet weak var muteButton: IMAStatefulButton!
    @IBOutlet weak var fullscreenButton: IMAStatefulButton!
    
    weak var handle: IMAHelper?

    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    /// Toggle Play Pause
    @IBAction func togglePlayPause(_ sender: Any) {
        self.handle?.setPlayPause()
    }
    
    /// Toggle Mute
    @IBAction func toggleMute(_ sender: Any) {
        self.handle?.setMute()
    }
    
    /// Toggle Fullscreen
    @IBAction func toggleFullscreen(_ sender: Any) {
        self.handle?.setFullscreen()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), NSStringFromClass(hitView.classForCoder).split(separator: ".").last == "IMAStatefulButton" {
            return hitView
        }
        return nil
    }
    
}
