//
//  MAVPlayer.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/12/7.
//  Copyright © 2018 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

fileprivate let VIDEO_URL = "https://tkx.apis.anvato.net/rest/v2/mcp/video/10014056?anvack=4eBjrEPvIlaqxefJYWmNI5gxBlTKXr8x&eud=hhFzPiGOH6SR9LPWwmrydVg2jeXFFzpsYskKaAh41MyW0KMQjsim%2BQWT7myiQxpBTyO8KsbFw40vgX8hrw%2Bxqw%3D%3D"

class MAVPlayer: UIViewController {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerView2: UIView!
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerViewController: AVPlayerViewController?
    
    var CTPlayer: CTPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.reset()
        
        self.CTPlayer?.pause()
        self.CTPlayer = nil
    }
    
    @objc func playerDidFinishPlaying() {
        print("Player Did Finish Playing")
    }
    
    func reset() {
        self.player?.pause()
        self.playerViewController?.removeFromParent()
        self.playerViewController?.view.removeFromSuperview()
        
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        
        self.player = nil
        self.playerItem = nil
        self.playerViewController = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            // 缓冲进度
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            
        }
        else if keyPath == "status" {
            // 监听状态改变(一共三种状态unknown、readyToPlay、failed)
            if playerItem.status == AVPlayerItem.Status.readyToPlay {
                // 只有在readyToPlay这个状态下才能播放
                print("播放")
                self.player?.play()
            }
            else {
                print("加载异常")
            }
        }
    }
    
    @IBAction func playerController(_ sender: Any) {
        self.reset()
        
        guard let videoURL = URL(string: VIDEO_URL) else {
            return
        }
        
        self.playerItem = AVPlayerItem(url: videoURL)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.allowsPictureInPicturePlayback = true
        
        self.playerViewController = playerViewController
        
        addChild(playerViewController)
        self.playerView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: self.playerView.frame.size.width, height: self.playerView.frame.size.height)
        
    }
    
    @IBAction func mobilePlayer(_ sender: Any) {
        guard let videoURL = URL(string: VIDEO_URL) else {
            return
        }
        
        let item = CTPlayerItem(url: videoURL)
        item.title = "CTPlayerView"
        item.ADURL = "https://ad.ettoday.net/videojs/ads_vp.php?bid=boba_preroll_app_beta"
        
        let playerView = CTPlayerView(frame: self.playerView.bounds)
        playerView.set(item: item)
        
        self.playerView.addSubview(playerView)
        
        self.CTPlayer = playerView
    }
    @IBAction func mobilePlayer2(_ sender: Any) {
        guard let videoURL = URL(string: VIDEO_URL) else {
            return
        }

        let item = CTPlayerItem(url: videoURL)
        item.title = "CTPlayerView2"
        item.ADURL = "https://ad.ettoday.net/videojs/ads_vp.php?bid=boba_preroll_app_beta"

        let playerView = CTPlayerView(frame: self.playerView2.bounds)
        playerView.set(item: item)

        self.playerView2.addSubview(playerView)        
    }
}
