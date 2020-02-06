//
//  AssistiveTouch.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/23.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class AssistiveTouch: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    let screenBounds = UIScreen.main.bounds
    var ballWindow: CustomUIWindow!

    override func viewDidLoad() {
        super.viewDidLoad()

        ballWindow = CustomUIWindow(frame: CGRect(x: screenBounds.width - 68, y: 65, width: 65, height: 65))
             
        textField.delegate = self
        
        print("alert \(UIWindow.Level.alert)") //2000
        print("normal \(UIWindow.Level.normal)") //0
        print("statusBar \(UIWindow.Level.statusBar)") //1000
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeVisible(_:)), name: UIWindow.didBecomeVisibleNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ballWindow?.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeVisibleNotification, object: nil)
    }
    
    @objc func windowDidBecomeVisible(_ notification:Notification){
        
        let window = notification.object as! UIWindow
        let windows = UIApplication.shared.windows
        
        print("\nwindow目前總數：\(windows.count)")
        print("Become Visible資訊：\(window)")
        print("windowLevel數值：\(window.windowLevel)\n")
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let alert = UIAlertController(title: "alert", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let actionSheet = UIAlertController(title: "actionSheet", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension AssistiveTouch: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
