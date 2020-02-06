//
//  CTPlayer.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/12.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVFoundation

class CTPlayer: AVPlayer {
    
    /// CTPlayerView instance
    weak var handler: CTPlayerView!
    
    /// Whether player is buffering
    var isBuffering: Bool = false
    
    /// Whether player is first time play
    var isFirstPlay: Bool = true
    
    var percent: Float = -1.0 {
        didSet {
            if oldValue != percent  {
                
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemTimeJumped, object: self)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self)
    }
    
    /// Play content
    override func play() {
        if isFirstPlay {
            isFirstPlay = false
        }
        
        handler?.playbackWillBegin(player: self)
        super.play()
        handler?.isPlaying = true
        handler?.playbackDidBegin(player: self)
    }
    
    /// Pause content
    override func pause() {
        super.pause()
        handler?.isPlaying = false
        handler?.playbackDidPause(player: self)
    }
    
    /// Replace current item with a new one
    override func replaceCurrentItem(with item: AVPlayerItem?) {
        if currentItem != nil {
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            currentItem!.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferFull")
            currentItem!.removeObserver(self, forKeyPath: "status")
        }
        
        super.replaceCurrentItem(with: item)
        if item != nil {
            currentItem!.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            currentItem!.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            currentItem!.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            currentItem!.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        }
    }
    
    /// Seek end update GASendCheck value
    func seekEnd(to time: CMTime) {
        
    }
}

extension CTPlayer {
    
    /// Start time
    func startTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.reversePlaybackEndTime.isValid {
            return item.reversePlaybackEndTime
        }
        else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
    }
    
    /// End time
    func endTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.forwardPlaybackEndTime.isValid {
            return item.forwardPlaybackEndTime
        }
        else {
            if item.duration.isValid && !item.duration.isIndefinite {
                return item.duration
            }
            else {
                return CMTime()
            }
        }
    }
    
    /// Prepare players playback delegate observers
    func preparePlayerPlaybackDelegate() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            self.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            self.handler?.playbackDidEnd(player: self)
        }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemTimeJumped, object: self, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            self.handler?.playbackDidJump(player: self)
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] (nitification) in
            guard let self = self else { return }
            if self.imaHelper.isFinish && self.handler.isPlaying {
                self.handler?.play()
            }
        }
        addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 100),
            queue: DispatchQueue.main) { [weak self] (time) in
                guard let self = self else { return }
                if !self.endTime().seconds.isNaN {
                    self.percent = round(Float(time.seconds / self.endTime().seconds) * 100) / 100
                }
                self.handler?.timeDidChange(player: self, to: time)
        }
        
        addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    /// Value observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? CTPlayer, obj == self {
            if keyPath == "status" {
                switch status {
                case AVPlayer.Status.readyToPlay:
                    handler?.playbackReady(player: self)
                case AVPlayer.Status.failed:
                    handler?.playbackDidFailed(with: CTPlayerPlaybackError.unknown)
                default:
                    break;
                }
            }
        }
        else {
            switch keyPath ?? "" {
            case "status":
                if let value = change?[.newKey] as? Int, let status = AVPlayerItem.Status(rawValue: value), let item = object as? AVPlayerItem {
                    if status == .failed, let error = item.error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                        var playbackError = CTPlayerPlaybackError.unknown
                        switch underlyingError.code {
                        case -12937:
                            playbackError = .authenticationError
                        case -16840:
                            playbackError = .unauthorized
                        case -12660:
                            playbackError = .forbidden
                        case -12938:
                            playbackError = .notFound
                        case -12661:
                            playbackError = .unavailable
                        case -12645, -12889:
                            playbackError = .mediaFileError
                        case -12318:
                            playbackError = .bandwidthExceeded
                        case -12642:
                            playbackError = .playlistUnchanged
                        case -1004:
                            playbackError = .wrongHostIP
                        case -1003:
                            playbackError = .wrongHostDNS
                        case -1000:
                            playbackError = .badURL
                        case -1202:
                            playbackError = .invalidRequest
                        default:
                            playbackError = .unknown
                        }
                        handler?.playbackDidFailed(with: playbackError)
                    }
                }
            case "playbackBufferEmpty":
                isBuffering = true
                handler?.startBuffering(player: self)
            case "playbackLikelyToKeepUp":
                isBuffering = false
                handler?.endBuffering(player: self)
            case "playbackBufferFull":
                isBuffering = false
                handler?.endBuffering(player: self)
            default:
                break;
            }
        }
    }
}
