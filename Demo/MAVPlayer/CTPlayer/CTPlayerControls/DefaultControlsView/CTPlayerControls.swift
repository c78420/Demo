//
//  CTPlayerControls.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVFoundation

class CTPlayerControls: UIView {

    /// CTPlayerView intance being controlled
    weak var handler: CTPlayerView!
    
    /// CTStatefulButton instance to represent the play/pause button
    @IBOutlet weak var playPauseButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the fullscreen toggle button
    @IBOutlet weak var fullscreenButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the mute toggle button
    @IBOutlet weak var muteButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the rewind button
    @IBOutlet weak var rewindButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the forward button
    @IBOutlet weak var forwardButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the skip forward button
    @IBOutlet weak var skipForwardButton: CTStatefulButton? = nil
    
    /// CTStatefulButton instance to represent the skip backward button
    @IBOutlet weak var skipBackwardButton: CTStatefulButton? = nil
    
    /// CTSeekbarSlider instance to represent the seekbar slider
    @IBOutlet weak var seekbarSlider: CTSeekbarSlider? = nil
    
    /// CTTimeLabel instance to represent the current time label
    @IBOutlet weak var currentTimeLabel: CTTimeLabel? = nil
    
    /// CTTimeLabel instance to represent the total time label
    @IBOutlet weak var totalTimeLabel: CTTimeLabel? = nil
    
    /// UIView to be shown when buffering
    @IBOutlet weak var bufferingView: UIActivityIndicatorView? = nil
    
    /// UIProgressView to shown load buffer
    @IBOutlet weak var progressView: UIProgressView? = nil
    
    /// UILabel to shown title
    @IBOutlet weak var titleLabel: UILabel? = nil
    
    private var wasPlayingBeforeRewinding: Bool = false
    private var wasPlayingBeforeForwarding: Bool = false
    private var wasPlayingBeforeSeeking: Bool = false
    
    /// Skip size in seconds to be used for skipping forward or backwards
    var skipSize: Double = 30
    
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
        
        rewindButton?.addTarget(self, action: #selector(rewindToggle), for: .touchUpInside)
        
        forwardButton?.addTarget(self, action: #selector(forwardToggle), for: .touchUpInside)
        
        skipForwardButton?.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
        skipBackwardButton?.addTarget(self, action: #selector(skipBackward), for: .touchUpInside)
        
        muteButton?.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
        muteButton?.set(active: handler.isMute)
        
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: handler.player.currentTime().seconds)
        
        seekbarSlider?.addTarget(self, action: #selector(playheadChanged(with:)), for: .valueChanged)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpInside)
        seekbarSlider?.addTarget(self, action: #selector(seekingEnd), for: .touchUpOutside)
        seekbarSlider?.addTarget(self, action: #selector(seekingStart), for: .touchDown)
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
    
    /// Notifies when time changes
    func timeDidChange(toTime time: CMTime) {
        currentTimeLabel?.update(toTime: time.seconds)
        totalTimeLabel?.update(toTime: handler.player.endTime().seconds)
        setSeekbarSlider(start: handler.player.startTime().seconds, end: handler.player.endTime().seconds, at: time.seconds)
        
        if let duration = handler.player.currentItem?.asset.duration, !duration.isIndefinite {
            setloadProgress(percent: availableDuration() / duration.seconds)
        }
    }
    
    func setSeekbarSlider(start startValue: Double, end endValue: Double, at time: Double) {
        seekbarSlider?.minimumValue = Float(startValue)
        seekbarSlider?.maximumValue = endValue.isNaN ? 0 : Float(endValue)
        seekbarSlider?.value = Float(time)
    }
    
    func setloadProgress(percent: Double) {
        progressView?.progress = percent.isNaN ? 0 : Float(percent)
    }
    
    fileprivate func availableDuration() -> TimeInterval {
        if let range = handler.player.currentItem?.loadedTimeRanges.first as? CMTimeRange {
            let smart  = CMTimeGetSeconds(CMTimeAdd(range.start, range.duration))
            return smart
        }
        return 0.0
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
    
    /// Skip forward (n) seconds in time
    @IBAction func skipForward(sender: Any? = nil) {
        let time = handler.player.currentTime() + CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// Skip backward (n) seconds in time
    @IBAction func skipBackward(sender: Any? = nil) {
        let time = handler.player.currentTime() - CMTime(seconds: skipSize, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.player.seek(to: time)
    }
    
    /// End seeking
    @IBAction func seekingEnd(sender: Any? = nil) {
        handler.isSeeking = false
        if wasPlayingBeforeSeeking {
            playPauseButton?.set(active: true)
            handler.play()
        }
        if let slider = sender as? UISlider {
            let value = Double(slider.value)
            let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            handler.playheadChangedEnd(time: time)
        }
    }
    
    /// Start Seeking
    @IBAction func seekingStart(sender: Any? = nil) {
        wasPlayingBeforeSeeking = handler.isPlaying
        handler.isSeeking = true
        playPauseButton?.set(active: false)
        handler.pause()
    }
    
    /// Playhead changed in UISlider
    @IBAction func playheadChanged(with sender: UISlider) {
        handler.isSeeking = true
        let value = Double(sender.value)
        let time = CMTime(seconds: value, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        handler.playheadChanged(time: time)
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
    
    /// Toggle rewind
    @IBAction func rewindToggle(sender: Any? = nil) {
        if handler.player.currentItem?.canPlayFastReverse ?? false {
            if handler.isRewinding {
                rewindButton?.set(active: false)
                handler.player.rate = 1
                if wasPlayingBeforeRewinding {
                    playPauseButton?.set(active: true)
                    handler.play()
                }
                else {
                    playPauseButton?.set(active: false)
                    handler.pause()
                }
            }
            else {
                playPauseButton?.set(active: false)
                rewindButton?.set(active: true)
                wasPlayingBeforeRewinding = handler.isPlaying
                if !handler.isPlaying {
                    playPauseButton?.set(active: true)
                    handler.play()
                }
                handler.player.rate = -1
            }
        }
    }
    
    /// Forward toggle
    @IBAction func forwardToggle(sender: Any? = nil) {
        if handler.player.currentItem?.canPlayFastForward ?? false {
            if handler.isForwarding {
                forwardButton?.set(active: false)
                handler.player.rate = 1
                if wasPlayingBeforeForwarding {
                    playPauseButton?.set(active: true)
                    handler.play()
                }
                else {
                    playPauseButton?.set(active: false)
                    handler.pause()
                }
            }
            else {
                playPauseButton?.set(active: false)
                forwardButton?.set(active: true)
                wasPlayingBeforeForwarding = handler.isPlaying
                if !handler.isPlaying {
                    playPauseButton?.set(active: true)
                    handler.play()
                }
                handler.player.rate = 2
            }
        }
    }
    
    /// Toggle mute
    @IBAction func toggleMute(sender: Any? = nil) {
        muteButton?.set(active: !handler.isMute)
        handler.setMute(enabled: !handler.isMute)
    }
}

extension CTPlayerControls: CTPlayerPlaybackDelegate {
    func timeDidChange(player: CTPlayer, to time: CMTime) {
        timeDidChange(toTime: time)
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
