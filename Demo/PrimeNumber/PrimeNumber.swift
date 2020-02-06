//
//  PrimeNumber.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/11.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class PrimeNumber: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func doThePrimeTest(_ sender: Any) {
        guard let inputNumberString = self.inputTextField.text, let inputNumberInt = Int(inputNumberString) else {
            return
        }
        
//        self.resultLabel.text = self.checkPrime(withNumber: Int(inputNumberInt))
//        self.resultLabel.isHidden = false

        self.checkPrime(withNumber: Int(inputNumberInt)) {
            self.resultLabel.text = $0
            self.resultLabel.isHidden = false
        }
        
        self.inputTextField.text = ""
    }
    
    func checkPrime(withNumber testNumber: Int) -> String {
        var isPrime: Bool? = true
        
        if testNumber <= 0 {
            isPrime = nil
        }
        else if testNumber == 1 {
            isPrime = false
        }
        else {
            for i in 2..<testNumber {
                if testNumber % i == 0 {
                    isPrime = false
                    break
                }
            }
        }
        
        if isPrime == true {
            return "\(testNumber) is prime"
        }
        else if isPrime == false {
            return "\(testNumber) is not prime"
        }
        else {
            return "reenter"
        }
    }
    
    func checkPrime(withNumber number:Int, andCompletionHandler handler:(String) -> ()) {
        handler(self.checkPrime(withNumber: number))
    }
}
