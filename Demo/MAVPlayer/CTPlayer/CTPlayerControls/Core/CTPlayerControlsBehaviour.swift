//
//  CTPlayerControlsBehaviour.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Foundation

class CTPlayerControlsBehaviour {
    
    /// CTPlayerControls instance being controlled
    weak var controls: (UIView & CTPlayerPlaybackDelegate)!
    
    /// CTPlayerView intance being controlled
    weak var handler: CTPlayerView!
    
    /// Whether controls are bieng displayed
    var showingControls: Bool = true
    
    /// Whether controls should be hidden when showingControls is true
    var shouldHideControls: Bool = true
    
    /// Whether controls should be shown when showingControls is false
    var shouldShowControls: Bool = true
    
    /// Elapsed time between controls being shown and current time
    private var elapsedTime: TimeInterval = 0
    
    /// Last time when controls were shown
    private var activationTime: TimeInterval = 0
    
    /// At which TimeInterval controls hide automatically
    var deactivationTimeInterval: TimeInterval = 3
    
    /// Custom deactivation block
    var deactivationBlock: (((UIView & CTPlayerPlaybackDelegate)) -> Void)? = nil
    
    /// Custom activation block
    var activationBlock: (((UIView & CTPlayerPlaybackDelegate)) -> Void)? = nil
    
    /// Constructor
    init(with controls: (UIView & CTPlayerPlaybackDelegate)) {
        self.controls = controls
    }
    
    /// Update ui based on time
    func update(with time: TimeInterval) {
        elapsedTime = time
        if showingControls && shouldHideControls && !handler.player.isBuffering && !handler.isSeeking && handler.isPlaying {
            let timediff = elapsedTime - activationTime
            if timediff >= deactivationTimeInterval {
                hide()
            }
        }
    }
    
    /// Default activation block
    func defaultActivationBlock(_ isAnimation: Bool = true) {
        controls.isHidden = false
        UIView.animate(withDuration: isAnimation ? 0.3 : 0.0) {
            self.controls.alpha = 1
        }
    }
    
    /// Default deactivation block
    func defaultDeactivationBlock(_ isAnimation: Bool = true) {
        UIView.animate(withDuration: isAnimation ? 0.3 : 0.0, animations: {
            self.controls.alpha = 0
        }) {
            if $0 {
                self.controls.isHidden = true
            }
        }
    }
    
    /// Hide the controls
    func hide(isAnimation: Bool = true) {
        if deactivationBlock != nil {
            deactivationBlock!(controls)
        }
        else {
            defaultDeactivationBlock(isAnimation)
        }
        showingControls = false
    }
    
    /// Show the controls
    func show(isAnimation: Bool = true) {
        if !shouldShowControls {
            return
        }
        activationTime = elapsedTime
        if activationBlock != nil {
            activationBlock!(controls)
        }
        else {
            defaultActivationBlock(isAnimation)
        }
        showingControls = true
    }
}
