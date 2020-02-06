//
//  CTPlayerView.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/12.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation
import AVKit

class CTPlayerView: UIView {
    static let CTPlayerNotificationNameFullscreen: String = "CT_PLAYER_FULLSCREEN_NAME"
    static let CTPlayerNotificationKeyFullscreen: String = "CT_PLAYER_FULLSCREEN_KEY"
    
    /// AVPlayer used in CTPlayer implementation
    var player: CTPlayer!
    
    /// CTPlayerControlsCoordinator instance being used to display controls
    var controlsCoordinator: CTPlayerControlsCoordinator? = nil
    
    /// CTPlayerRenderingView instance
    var renderingView: CTPlayerRenderingView!

    /// CTPlayerPlaybackDelegate instance
    weak var playbackDelegate: CTPlayerPlaybackDelegate? = nil
    
    /// CTPlayerItem instance
    weak var playerItem: CTPlayerItem? = nil
    
    /// Whether player is prepared
    var ready: Bool = false
    
    /// Whether it should autoplay when adding a VPlayerItem
    var autoplay: Bool = true
    
    /// Whether Player is currently playing
    var isPlaying: Bool = false
    
    /// Whether Player is seeking time
    var isSeeking: Bool = false
    
    /// Whether Player is presented in Fullscreen
    var isFullscreenModeEnabled: Bool = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CTPlayerView.CTPlayerNotificationNameFullscreen), object: self, userInfo: [CTPlayerView.CTPlayerNotificationKeyFullscreen: isFullscreenModeEnabled])
        }
    }
    
    var isTransitioning: Bool = false
    
    /// Whether Player is Fast Forwarding
    var isForwarding: Bool {
        return player.rate > 1
    }
    
    /// Whether Player is Rewinding
    var isRewinding: Bool {
        return player.rate < 0
    }
    
    /// Whether Player is Mute
    var isMute: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override func layoutSubviews() {
        if isTransitioning {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
    
    /// Prepares the player to play
    fileprivate func prepare() {
        ready = true
        player = CTPlayer()
        player.isMuted = isMute
        player.handler = self
        player.preparePlayerPlaybackDelegate()
        renderingView = CTPlayerRenderingView(with: self)
        layout(view: renderingView, into: self)
        self.layer.backgroundColor = UIColor.black.cgColor
        
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [.mixWithOthers])
            } else {
                // Fallback on earlier versions
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playback, with: [])
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {}
    }
    
    /// Layout a view within another view stretching to edges
    fileprivate func layout(view: UIView, into: UIView? = nil) {
        guard let into = into else {
            return
        }
        into.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: into.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: into.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: into.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: into.bottomAnchor).isActive = true
    }
    
    /// CTPlayerControls instance to display controls in player, using CTPlayerGestureRecieverView instance
    fileprivate func use(controls: (UIView & CTPlayerPlaybackDelegate), with gestureReciever: CTPlayerGestureRecieverView? = nil) {
        if controlsCoordinator != nil {
            controlsCoordinator?.removeFromSuperview()
            controlsCoordinator = nil
        }

        self.playbackDelegate = controls
        let coordinator = CTPlayerControlsCoordinator()
        controlsCoordinator = coordinator
        coordinator.player = self
        coordinator.controls = controls
        coordinator.gestureReciever = gestureReciever
        addSubview(coordinator)
        bringSubviewToFront(coordinator)
    }
    
    /// Sets the item to be played
    func set(item: CTPlayerItem?, controls: (UIView & CTPlayerPlaybackDelegate)? = nil, isLive: Bool = false) {
        if !ready {
            prepare()
        }
        playerItem = item
        player.replaceCurrentItem(with: item)
        
        if let controls = controls {
            use(controls: controls)
        }
        else {
            if isLive {
                if let playerControlsView = Bundle.main.loadNibNamed("CTLivePlayerControlsView", owner: self, options: nil)?.last as? CTLivePlayerControls {
                    playerControlsView.setTitle(title: item?.title)
                    use(controls: playerControlsView)
                }
            }
            else {
                if let playerControlsView = Bundle.main.loadNibNamed("CTPlayerControlsView", owner: self, options: nil)?.last as? CTPlayerControls {
                    playerControlsView.setTitle(title: item?.title)
                    use(controls: playerControlsView)
                }
            }
        }
        
        if let url = item?.ADURL {
            controlsCoordinator?.behaviour.hide(isAnimation: false)
            player.imaHelper.play(url: url, container: self)
        }
        else {
            if autoplay && item?.error == nil {
                play()
            }
        }
    }
}

// MARK: - Value update
extension CTPlayerView {
    /// Player update time
    func timeDidChange(player: CTPlayer, to time: CMTime) {
        if !(isSeeking || isRewinding || isForwarding) {
            controlsCoordinator?.behaviour.update(with: time.seconds)
        }
        
        playbackDelegate?.timeDidChange(player: player, to: time)
    }
    
    /// LandscapeWindow notification fullscreen
    func updateFullscreen(_ isFullscreen: Bool) {
        isFullscreenModeEnabled = isFullscreen
        playbackDelegate?.playbackFullscreen(isFullscreen: isFullscreen)
        
        if !player.imaHelper.isFinish {
            player.imaHelper.updateFullscreen(isFullscreen)
        }
    }
    
    /// Enables or disables fullscreen
    func setFullscreen(enabled: Bool) {
        if enabled == isFullscreenModeEnabled {
            return
        }
        
        isFullscreenModeEnabled = enabled
        playbackDelegate?.playbackFullscreen(isFullscreen: enabled)
        
        if enabled {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            CTLandscapeWindow.shared.makeKey(playerView: self)
        }
        else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            CTLandscapeWindow.shared.portraitLayout()
        }
    }
    
    /// Enables or disables mute
    func setMute(enabled: Bool) {
        player.isMuted = enabled
        
        isMute = enabled
        
        playbackDelegate?.playbackMute(isMute: enabled)
    }
    
    /// Hide controls
    func hideControls() {
        controlsCoordinator?.behaviour.hide()
    }
    
    /// Controls slider update time
    func playheadChanged(time: CMTime) {
        player.seek(to: time)
        controlsCoordinator?.behaviour.update(with: time.seconds)
        controlsCoordinator?.behaviour.show()
    }
    
    /// Controls slider update time end
    func playheadChangedEnd(time: CMTime) {
        player.seekEnd(to: time)
    }
    
    /// Play
    func play() {
        if !player.imaHelper.isFinish {
            player.imaHelper.adsManager?.resume()
        }
        else {
            player.play()
        }
    }
    
    /// Pause
    func pause() {
        if !player.imaHelper.isFinish {
            player.imaHelper.adsManager?.pause()
        }
        else {
            player.pause()
            controlsCoordinator?.behaviour?.show()
        }
    }
}

// MARK: - Status update
extension CTPlayerView {
    func playbackReady(player: CTPlayer) {
        playbackDelegate?.playbackReady(player: player)
    }
    
    func playbackWillBegin(player: CTPlayer) {
        playbackDelegate?.playbackWillBegin(player: player)
    }
    
    func playbackDidBegin(player: CTPlayer) {
        playbackDelegate?.playbackDidBegin(player: player)
    }
    
    func playbackDidFailed(with error: CTPlayerPlaybackError) {
        player.pause()
        controlsCoordinator?.behaviour?.show()
        playbackDelegate?.playbackDidFailed(with: error)
    }
    
    func playbackDidPause(player: CTPlayer) {
        playbackDelegate?.playbackDidPause(player: player)
    }
    
    func playbackDidEnd(player: CTPlayer) {
        player.pause()
        controlsCoordinator?.behaviour?.update(with: 0)
        controlsCoordinator?.behaviour?.show()
        playbackDelegate?.playbackDidEnd(player: player)
    }
    
    func startBuffering(player: CTPlayer) {
        controlsCoordinator?.behaviour?.show()
        playbackDelegate?.startBuffering(player: player)
    }
    
    func endBuffering(player: CTPlayer) {
        playbackDelegate?.endBuffering(player: player)
    }
    
    func playbackDidJump(player: CTPlayer) {
        playbackDelegate?.playbackDidJump(player: player)
    }
}
