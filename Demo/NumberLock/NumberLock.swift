//
//  NumberLock.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/6/10.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import GameKit

let MAX_NUMBER = 100
let MIN_NUMBER = 1

class NumberLock: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backgroung: UIImageView!
    
    var answer: Int = 0
    var maxNumber: Int = 0
    var minNumber: Int = 0
    var isOver: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // push the keyboard up
        self.inputTextField.becomeFirstResponder()
        
        self.gameSetting()
    }
    
    @IBAction func makeAGess(_ sender: Any) {
        if self.isOver == false {
            print("answer : \(answer)")
            
            guard let inputText = self.inputTextField.text else {
                print("input text error")
                return
            }
            print("inputText : \(inputText)")
            
            self.inputTextField.text = ""
            
            guard let inputNumber = Int(inputText) else {
                self.showMessage(message: "No input! Gess a number between \(self.minNumber) ~ \(self.maxNumber)")
                return
            }
            
            if inputNumber > MAX_NUMBER {
                self.showMessage(message: "Too large! Gess a number between \(self.minNumber) ~ \(self.maxNumber)")
                return
            }
            else if inputNumber < MIN_NUMBER {
                self.showMessage(message: "Too small! Gess a number between \(self.minNumber) ~ \(self.maxNumber)")
                return
            }
            else if inputNumber == self.answer {
                self.showMessage(message: "Yoe are right, Press [Guess] to play again!")
                self.isOver = true
                self.backgroung.image = UIImage(named: "Finish")
                return
            }
            else {
                if inputNumber > self.answer {
                    // large than answer
                    self.maxNumber = inputNumber
                }
                else {
                    // small than answer
                    self.minNumber = inputNumber
                }
                self.showMessage(message: "Try again! Gess a number between \(self.minNumber) ~ \(self.maxNumber)")
                return
            }
        } else {
            self.gameSetting()
        }
    }
    
    func gameSetting() {
        self.maxNumber = MAX_NUMBER
        self.minNumber = MIN_NUMBER
        self.messageLabel.text = "Gess a number between \(self.minNumber) ~ \(self.maxNumber)"
        self.answer = GKRandomSource.sharedRandom().nextInt(upperBound: MAX_NUMBER) + MIN_NUMBER
        self.isOver = false
        self.backgroung.image = UIImage(named: "BG")
    }
    
    func showMessage(message: String?) {
        guard let message = message else {
            print("showMessage error")
            return
        }
        
        self.messageLabel.text = message
    }
}
