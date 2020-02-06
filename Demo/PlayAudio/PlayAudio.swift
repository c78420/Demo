//
//  PlayAudio.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/6/30.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class PlayAudio: UIViewController {
    
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    var recordHelper: RecordHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordHelper = RecordHelper()
    }
    
    @IBAction func Play(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "Right", ofType: "mp3") {
            self.recordHelper?.Play(fileURL: URL(fileURLWithPath: path))
        }
    }
    @IBAction func Stop(_ sender: Any) {
        self.recordHelper?.StopPlay()
    }
    @IBAction func loopChange(_ sender: UISwitch) {
        if let player = self.recordHelper?.audioPlayer {
            if sender.isOn {
                player.numberOfLoops = -1
            }
            else {
                player.numberOfLoops = 0
            }
        }
        else {
            sender.setOn(false, animated: true)
        }
    }
    @IBAction func volumeChange(_ sender: UIStepper) {
        if let player = self.recordHelper?.audioPlayer {
            self.volume.text = String(sender.value)
            player.volume = Float(sender.value)
        }
        else {
            self.volume.text = "1.0"
            sender.value = 1.0
        }
    }
    @IBAction func speedChange(_ sender: UIStepper) {
        if let player = self.recordHelper?.audioPlayer {
            self.speed.text = String(sender.value)
            player.rate = Float(sender.value)
        }
        else {
            self.speed.text = "1.0"
            sender.value = 1.0
        }
    }
}

extension PlayAudio {
    @IBAction func Record(_ sender: Any) {
        self.recordHelper?.Record()
    }
    
    @IBAction func StopRecord(_ sender: Any) {
        self.recordHelper?.StopRecord()
    }
    
    @IBAction func PlayRecord(_ sender: Any) {
        self.recordHelper?.Play()
    }
    
    @IBAction func StopPlayRecord(_ sender: Any) {
        self.recordHelper?.StopPlay()
    }
}
