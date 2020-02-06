//
//  IMAHelper.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/23.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Foundation
import GoogleInteractiveMediaAds

fileprivate var AdHelperKey = "PLayerADHelperKey"
extension AVPlayer {
    var imaHelper: IMAHelper {
        set {
            objc_setAssociatedObject(self, &AdHelperKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let obj = objc_getAssociatedObject(self, &AdHelperKey) as? IMAHelper {
                return obj
            }
            else {
                self.imaHelper = IMAHelper(self)
                return self.imaHelper
            }
        }
    }
}

class IMAHelper: NSObject {
    fileprivate var didBecomeActiveObserver: Any?
    fileprivate var adsLoader: IMAAdsLoader?
    
    weak var container: CTPlayerView!
    unowned let player: AVPlayer
    weak var controls: IMAControls?
    
    var isPlay: Bool = false
    var isFinish: Bool = true

    var percent: Float = -1.0 {
        didSet {
            if oldValue != percent  {
                
            }
        }
    }
    var adsManager: IMAAdsManager? {
        didSet {
            oldValue?.destroy()
        }
    }
    
    init(_ player: AVPlayer) {
        self.player = player
    }
    
    deinit {
        
    }
    
    func play(url: String, container: CTPlayerView?) {
        guard let c = container else {
            return
        }
        self.container = c
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: c, companionSlots: nil)
        let contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.player)
        let request = IMAAdsRequest(
            adTagUrl: url,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        let imaSetting = IMASettings()
        imaSetting.language = "zh_tw"
        self.adsLoader = IMAAdsLoader(settings: imaSetting)
        self.adsLoader?.delegate = self
        self.adsLoader?.requestAds(with: request)
        self.addObserver()
    }
    
    func stop() {
        self.container = nil
        self.isPlay = false
        self.adsManager?.pause()
        self.adsManager?.destroy()
        self.adsManager = nil
        self.adsLoader = nil
        self.removeControls()
        self.removeobserver()
    }
    
    fileprivate func playerPlay() {
        self.isFinish = true
        if self.isPlay {
            self.container.play()
        }
    }
    
    /// Controls Toggle Mute
    func setMute() {
        let isMute = self.container.isMute
        self.container.setMute(enabled: !isMute)
        self.adsManager?.volume = !isMute ? 0.0 : 1.0
        self.controls?.muteButton.set(active: !isMute)
    }
    
    /// Controls Toggle Play Pause
    func setPlayPause() {
        if self.isPlay {
            self.adsManager?.pause()
            self.isPlay = false
        }
        else {
            self.adsManager?.resume()
            self.isPlay = true
        }
        self.controls?.playPauseButton.set(active: self.isPlay)
    }
    
    /// Controls Toggle Fullscreen
    func setFullscreen() {
        let isFullscreen = self.container.isFullscreenModeEnabled
        self.container.setFullscreen(enabled: !isFullscreen)
        self.updateFullscreen(!isFullscreen)
    }
    
    /// LandscapeWindow notification fullscreen
    func updateFullscreen(_ isFullscreen: Bool) {
        self.controls?.fullscreenButton.set(active: isFullscreen)
    }
    
    fileprivate func addObserver() {
        if didBecomeActiveObserver == nil {
            didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil, using: { [weak self] (nitification) in
                if self?.isPlay ?? false {
                    self?.adsManager?.resume()
                }
            })
        }
    }
    
    fileprivate func removeobserver() {
        if let d = didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(d)
        }
        didBecomeActiveObserver = nil
    }
    
    fileprivate func addControls() {
        guard let imaControls = Bundle.main.loadNibNamed("IMAControlsView", owner: self, options: nil)?.last as? IMAControls else {
            return
        }
        self.controls = imaControls
        self.controls?.handle = self
        self.controls?.playPauseButton.set(active: self.isPlay)
        self.controls?.muteButton.set(active: self.container.isMute)
        self.controls?.fullscreenButton.set(active: self.container.isFullscreenModeEnabled)
        self.container?.addSubview(imaControls)
    }
    
    fileprivate func removeControls() {
        self.controls?.removeFromSuperview()
    }
}

extension IMAHelper: IMAAdsLoaderDelegate {
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        adsManager = adsLoadedData.adsManager
        adsManager?.volume = self.container.isMute ? 0.0 : 1.0
        adsManager?.delegate = self
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        
        adsManager?.initialize(with: adsRenderingSettings)
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        self.playerPlay()
        self.stop()
    }
}

extension IMAHelper: IMAAdsManagerDelegate {
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        switch event.type {
        case .LOADED:
            adsManager.start()
            self.isPlay = true
            self.isFinish = false
            self.addControls()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !self.container.autoplay {
                    self.setPlayPause()
                }
            }
        case .CLICKED:
            self.playerPlay()
            self.stop()
            break
        default:
            break
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        self.playerPlay()
        self.stop()
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        self.container.player.pause()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        self.playerPlay()
        self.stop()
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
        self.percent = round(Float(mediaTime / totalTime) * 100) / 100
    }
}
