//
//  CTPlayerPlaybackDelegate.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/12.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation
import AVFoundation

protocol CTPlayerPlaybackDelegate: AnyObject {
    
    /// Notifies when playback time changes
    func timeDidChange(player: CTPlayer, to time: CMTime)
    
    /// Whether if playback is skipping frames
    func playbackDidJump(player: CTPlayer)
    
    /// Notifies when player will begin playback
    func playbackWillBegin(player: CTPlayer)
    
    /// Notifies when playback is ready to play
    func playbackReady(player: CTPlayer)
    
    /// Notifies when playback did begin
    func playbackDidBegin(player: CTPlayer)
    
    /// Notifies when playback did pause
    func playbackDidPause(player: CTPlayer)
    
    /// Notifies when player ended playback
    func playbackDidEnd(player: CTPlayer)
    
    /// Notifies when player starts buffering
    func startBuffering(player: CTPlayer)
    
    /// Notifies when player ends buffering
    func endBuffering(player: CTPlayer)
    
    /// Notifies when playback fails with an error
    func playbackDidFailed(with error: CTPlayerPlaybackError)
    
    /// Notifies when playback fullscreen did change
    func playbackFullscreen(isFullscreen: Bool)
    
    /// Notifies when playback mute did change
    func playbackMute(isMute: Bool)
}
