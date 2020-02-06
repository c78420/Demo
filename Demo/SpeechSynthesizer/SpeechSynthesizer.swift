//
//  SpeechSynthesizer.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/9.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVFoundation

class SpeechSynthesizer: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var isPlaying: Bool = false
    var text: String = ""
    
    var speechUtterance: AVSpeechUtterance?
    var speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inputTextField.delegate = self
        self.speechSynthesizer.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func setupSpeechUtterance(text: String) {
        self.speechUtterance = AVSpeechUtterance(string: text)
        // 語言
        self.speechUtterance?.voice = AVSpeechSynthesisVoice(language: "zh-tw")
        // 語速 0.0～1.0
//        self.arabicSpeechUtterance?.rate = 1.0
        // 音調 0.5～2.0
//        self.arabicSpeechUtterance?.pitchMultiplier = 1.0
        // 播放下一句时延遲
//        self.arabicSpeechUtterance?.postUtteranceDelay = 0.1
    }

    @IBAction func togglePlay(_ sender: Any) {
        guard !self.text.isEmpty else {
            return
        }
        
        if self.isPlaying {
            self.speechSynthesizer.pauseSpeaking(at: .immediate)
            
            self.isPlaying = false
            
            self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
        else {
            if self.speechUtterance != nil {
                self.speechSynthesizer.continueSpeaking()
            }
            else {
                self.setupSpeechUtterance(text: self.text)
                
                self.speechSynthesizer.speak(self.speechUtterance!)
            }
            
            self.isPlaying = true
            
            self.playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        self.textLabel.text = self.inputTextField.text
        
        if self.text != self.inputTextField.text {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
            
            self.speechUtterance = nil
            
            self.text = self.inputTextField.text!
        }
    }
}

extension SpeechSynthesizer: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.isPlaying {
            self.speechSynthesizer.pauseSpeaking(at: .immediate)
            
            self.isPlaying = false
            
            self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        
        self.textLabel.text = textField.text
        
        if self.text != textField.text {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
            
            self.speechUtterance = nil
            
            self.text = self.inputTextField.text!
        }
        
        return true
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("speech didStart")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speech didFinish")
        
        self.speechUtterance = nil
        
        self.isPlaying = false
        
        self.playButton.setImage(UIImage(systemName: "play"), for: .normal)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("speech didPause")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("speech didContinue")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("speech didCancel")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        print("speech characterRange \(characterRange)")
    }
}
