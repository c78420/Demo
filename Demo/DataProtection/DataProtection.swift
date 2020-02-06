//
//  DataProtection.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/8.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import LocalAuthentication

class DataProtection: UIViewController {
    
    @IBAction func setDataProtection(_ sender: Any) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Fail to get Documents URL.")
            return
        }
        
        let file1URL = documentsURL.appendingPathComponent("Protected.plist")
        let file1Content = ["username": "kent"]
        ( file1Content as NSDictionary ).write(to: file1URL, atomically: true)
        
        let file2URL = documentsURL.appendingPathComponent("UnProtected.plist")
        let file2Content = ["username": "kent"]
        ( file2Content as NSDictionary ).write(to: file2URL, atomically: true)
        
        // Setup the protection
        let attributess = [FileAttributeKey.protectionKey: FileProtectionType.none]
        do {
            try FileManager.default.setAttributes(attributess, ofItemAtPath: file2URL.path)
        } catch {
            print("Set file attributes fail: \(error)")
        }
        
        // Check DataProtection status.
        let dataAvailable = UIApplication.shared.isProtectedDataAvailable
        print("Protected Data is Available " + (dataAvailable ? "Yes" : "No"))
    }
    
    @IBAction func LocalAuthentication(_ sender: Any) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            print("OK. We can make owner authentication")
        } else {
            print("User don't setup password.")
        }
    }
}
