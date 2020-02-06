//
//  RecordHelper.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/1.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation
import AVFoundation

enum AudioSessionMode {
    case record
    case play
}

class RecordHelper: NSObject, AVAudioRecorderDelegate {
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var isRecording: Bool = false
    
    override init() {
        super.init()
    }
    
    func playAudioSetting(fileURL: URL) {
        if self.audioPlayer?.url?.absoluteString != fileURL.absoluteString {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                self.audioPlayer?.enableRate = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func recordSetting() -> Bool {
        if self.audioRecorder != nil {
            return true
        }
        else {
            let fileName = "User.wav"
            let path = NSHomeDirectory() + "/Documents/" + fileName
            let url = URL(fileURLWithPath: path)
            
            let recordSettings: [String:Any] = [
                AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                AVEncoderBitRateKey: 16,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0
            ]
            
            do {
                self.audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
                self.audioRecorder?.delegate = self
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    }
    
    func Record() {
        if self.recordSetting() {
            self.settingAudioSession(toMode: .record)
            self.audioRecorder?.prepareToRecord()
            self.audioRecorder?.record()
            self.isRecording = true
        }
    }
    
    func StopRecord() {
        if self.audioRecorder != nil {
            self.audioRecorder?.stop()
            self.isRecording = false
        }
    }
    
    func Play() {
        self.settingAudioSession(toMode: .play)
        if self.isRecording == false {
            self.audioPlayer?.stop()
            self.audioPlayer?.currentTime = 0.0
            self.audioPlayer?.play()
        }
    }
    
    func Play(fileURL: URL) {
        self.playAudioSetting(fileURL: fileURL)
        
        self.Play()
    }
    
    func StopPlay() {
        if self.isRecording == false {
            self.audioPlayer?.stop()
            self.audioPlayer?.currentTime = 0.0
        }
    }
    
    func settingAudioSession(toMode mode: AudioSessionMode) {
        self.audioPlayer?.stop()
        
        let session = AVAudioSession.sharedInstance()
        do {
            switch mode {
            case .record:
                try session.setCategory(AVAudioSession.Category.record, mode: .default)
            case .play:
                try session.setCategory(AVAudioSession.Category.playback, mode: .default)
            }
            try session.setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            self.playAudioSetting(fileURL: recorder.url)
        }
    }
}
