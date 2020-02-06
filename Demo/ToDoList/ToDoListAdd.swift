//
//  ToDoListAdd.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/19.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ToDoListAdd: UIViewController {

    @IBOutlet weak var myTextInput: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    var infoFromViewOne: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myTextInput.becomeFirstResponder()
        self.myTextInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let info = self.infoFromViewOne {
            if var toDos = UserDefaults.standard.stringArray(forKey: "toDos") {
                self.myTextInput.text = toDos[info]
                self.myButton.setTitle("OK", for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPresses(_ sender: UIButton) {
        if let text = self.myTextInput.text, !text.isEmpty {
            if var toDos = UserDefaults.standard.stringArray(forKey: "toDos") {
                if let info = self.infoFromViewOne {
                    toDos[info] = text
                }
                else {
                    toDos.append(text)
                }
                
                UserDefaults.standard.set(toDos, forKey: "toDos")
            }
            else {
                UserDefaults.standard.set([text], forKey: "toDos")
            }
        }
        else {
            if let info = self.infoFromViewOne {
                if var toDos = UserDefaults.standard.stringArray(forKey: "toDos") {
                    toDos.remove(at: info)
                    
                    UserDefaults.standard.set(toDos, forKey: "toDos")
                }
            }
        }
        
        self.tabBarController?.selectedIndex = 0
        self.myTextInput.text = ""
        self.myButton.setTitle("Back", for: .normal)
        self.infoFromViewOne = nil
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        if sender.text != "" {
            self.myButton.setTitle("OK", for: .normal)
        }
        else {
            self.myButton.setTitle("Back", for: .normal)
        }
    }
}

extension ToDoListAdd: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.buttonPresses(self.myButton)
        return true
    }
}
