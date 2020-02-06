//
//  Calculator.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/2.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Calculator: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var numberOnScreen: Double = 0
    var previousNumber: Double = 0
    var performingMath = false
    var opertion: OperationType = .none
    var startNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func numbers(_ sender: UIButton) {
        let inputNumber = sender.tag - 1
        if let number = self.label.text, number.count < 9 {
            if number == "0" || self.startNew {
                self.label.text = "\(inputNumber)"
                self.startNew = false
            }
            else {
                self.label.text = number + "\(inputNumber)"
            }
            
            self.numberOnScreen = Double(self.label.text!) ?? 0
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        self.label.text = "+"
        if self.performingMath, self.opertion == .add {
            self.calculateTheAnswer()
        }
        self.opertion = .add
        self.performingMath = true
        self.previousNumber = self.numberOnScreen
        self.startNew = true
    }
    
    @IBAction func subtract(_ sender: UIButton) {
        self.label.text = "-"
        if self.performingMath, self.opertion == .subtract {
            self.calculateTheAnswer()
        }
        self.opertion = .subtract
        self.performingMath = true
        self.previousNumber = self.numberOnScreen
        self.startNew = true
    }
    
    @IBAction func multiply(_ sender: UIButton) {
        self.label.text = "x"
        if self.performingMath, self.opertion == .multiply {
            self.calculateTheAnswer()
        }
        self.opertion = .multiply
        self.performingMath = true
        self.previousNumber = self.numberOnScreen
        self.startNew = true
    }
    
    @IBAction func divide(_ sender: UIButton) {
        self.label.text = "/"
        if self.performingMath, self.opertion == .divide {
            self.calculateTheAnswer()
        }
        self.opertion = .divide
        self.performingMath = true
        self.previousNumber = self.numberOnScreen
        self.startNew = true
    }
    
    @IBAction func answer(_ sender: UIButton) {
        self.calculateTheAnswer()
    }
    
    func calculateTheAnswer() {
        if self.performingMath {
            let answer = CalculateHelper.shared.calculate(rightValue: previousNumber, leftValue: numberOnScreen, operation: self.opertion)
            self.label.text = answer
            self.numberOnScreen = Double(answer) ?? 0
            self.startNew = true
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        self.label.text = "0"
        self.numberOnScreen = 0
        self.previousNumber = 0
        self.performingMath = false
        self.opertion = .none
        self.startNew = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
