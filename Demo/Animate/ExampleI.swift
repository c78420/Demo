//
//  ExampleI.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/18.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ExampleI: UIViewController {

    @IBOutlet weak var centerAlignUsername: NSLayoutConstraint!
    @IBOutlet weak var centerAlignPassword: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerAlignUsername.constant += view.bounds.width
        centerAlignPassword.constant += view.bounds.width
        loginButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.centerAlignUsername.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.centerAlignPassword.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            self.loginButton.alpha = 1
        }, completion: nil)
    }

    @IBAction func login(_ sender: Any) {
        let bounds = self.loginButton.bounds
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: nil)
    }
}
