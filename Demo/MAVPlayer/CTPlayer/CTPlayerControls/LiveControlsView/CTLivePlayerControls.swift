//
//  CTLivePlayerControls.swift
//  newchinatimes
//
//  Created by Tony on 2019/3/5.
//  Copyright © 2019 Want-Want Annie. All rights reserved.
//

import UIKit
import AVFoundation

class CTLivePlayerControls: UIView {
    
    /// CTPlayerView intance being controlled
    weak var handler: CTPlayerView!
    
    /// CTStatefulButton instance to represent the play/pause button
    @IBOutlet weak var playPauseButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the fullscreen toggle button
    @IBOutlet weak var fullscreenButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the mute toggle button
    @IBOutlet weak var muteButton: CTStatefulButton? = nil
    
    /// UIView to be shown when buffering
    @IBOutlet weak var bufferingView: UIActivityIndicatorView? = nil
    
    /// UILabel to shown title
    @IBOutlet weak var titleLabel: UILabel? = nil

    /// UIView to shown live ststus
    @IBOutlet weak var liveStstus: UIImageView? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handler.hideControls()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutInSuperview()
    }
    
    func layoutInSuperview() {
        if let coordinator = superview as? CTPlayerControlsCoordinator {
            handler = coordinator.player
            prepare()
        }
    }
    
    /// Prepare controls targets and notification listeners
    func prepare() {
        stretchToEdges()
        
        playPauseButton?.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        
        fullscreenButton?.addTarget(self, action: #selector(toggleFullscreen), for: .touchUpInside)
        
        muteButton?.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
        muteButton?.set(active: handler.isMute)
        
        setLive(isLive: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stretchToEdges()
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
    
    func setTitle(title: String?) {
        titleLabel?.text = title
    }
    
    func setLive(isLive: Bool) {
        if isLive {
            liveStstus?.tintColor = UIColor.red
        }
        else {
            liveStstus?.tintColor = UIColor.gray
        }
    }
    
    /// Show buffering view
    func showBuffering() {
        bufferingView?.startAnimating()
        playPauseButton?.isHidden = true
    }
    
    /// Hide buffering view
    func hideBuffering() {
        bufferingView?.stopAnimating()
        playPauseButton?.isHidden = false
    }
    
    /// Toggle fullscreen mode
    @IBAction func toggleFullscreen(sender: Any? = nil) {
        handler.setFullscreen(enabled: !handler.isFullscreenModeEnabled)
    }
    
    /// Toggle playback
    @IBAction func togglePlayback(sender: Any? = nil) {
        if handler.isRewinding || handler.isForwarding {
            handler.player.rate = 1
            playPauseButton?.set(active: true)
            return;
        }
        if handler.isPlaying {
            playPauseButton?.set(active: false)
            handler.pause()
        }
        else {
            playPauseButton?.set(active: true)
            handler.play()
        }
    }
    
    /// Toggle mute
    @IBAction func toggleMute(sender: Any? = nil) {
        muteButton?.set(active: !handler.isMute)
        handler.setMute(enabled: !handler.isMute)
    }
}

extension CTLivePlayerControls: CTPlayerPlaybackDelegate {
    func timeDidChange(player: CTPlayer, to time: CMTime) {
        
    }
    
    func playbackDidJump(player: CTPlayer) {
        
    }
    
    func playbackWillBegin(player: CTPlayer) {
        
    }
    
    func playbackReady(player: CTPlayer) {
        
    }
    
    func playbackDidBegin(player: CTPlayer) {
        playPauseButton?.set(active: true)
    }
    
    func playbackDidPause(player: CTPlayer) {
        playPauseButton?.set(active: false)
    }
    
    func playbackDidEnd(player: CTPlayer) {
        playPauseButton?.setImage(UIImage(named: "CT_restart"), for: .normal)
    }
    
    func startBuffering(player: CTPlayer) {
        showBuffering()
    }
    
    func endBuffering(player: CTPlayer) {
        hideBuffering()
    }
    
    func playbackDidFailed(with error: CTPlayerPlaybackError) {
        showBuffering()
    }
    
    func playbackFullscreen(isFullscreen: Bool) {
        fullscreenButton?.set(active: isFullscreen)
    }
    
    func playbackMute(isMute: Bool) {
        muteButton?.set(active: isMute)
    }
}
