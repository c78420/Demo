//
//  DataSecurity.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/8.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import RNCryptor
import KeychainAccess

class DataSecurity: UIViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    
    // 加解密用的 key 不要用明碼顯示在程式中，透過程式碼運算出 key 值，能夠混淆駭客
    var primaryKey: String = {
        //        return "1234"
        //        return String( 12 * 100 + 34 )
        let result = String( ( "4" + String( 4 * 8 ) + "1" ).reversed() )
        return result
    }()
    
    @IBAction func EncryptFile(_ sender: Any) {
        guard let sourceURL = Bundle.main.url(forResource: "channelLogo.png", withExtension: nil) else {
            assertionFailure("Fail to get file from bundle.")
            return
        }
        
        guard let data = try? Data(contentsOf: sourceURL) else {
            assertionFailure("Fail to get file content.")
            return
        }
        
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: primaryKey)
        
        let tempURL = FileManager.default.temporaryDirectory
        let finalURL = tempURL.appendingPathComponent("output.x")
        try? encryptedData.write(to: finalURL)
        print("tempURL: \(tempURL)")
    }
    
    @IBAction func DecryptFile(_ sender: Any) {
        guard let sourceURL = Bundle.main.url(forResource: "output.x", withExtension: nil) else {
            assertionFailure("Fail to get file from bundle.")
            return
        }
        
        guard let data = try? Data(contentsOf: sourceURL) else {
            assertionFailure("Fail to get file content.")
            return
        }
        
        guard let decryptData = try? RNCryptor.decrypt(data: data, withPassword: primaryKey) else {
            assertionFailure("Fail to decrypt file.")
            return
        }
        
        self.resultImageView.image = UIImage(data: decryptData)
    }
    
    @IBAction func saveInKeychain(_ sender: Any) {
        let accessToken = "1qaz2wsx3edc"
        
        let keychain = Keychain(service: "main.server")
        keychain["accessToken"] = accessToken
    }
    
    @IBAction func loadFromKeychain(_ sender: Any) {
        let keychain = Keychain(service: "main.server")
        let result = keychain["accessToken"]
        
        print("accessToken: \(result)")
        
        // Clear only.
        keychain["accessToken"] = nil
        
        // Remove the key-value item.
        try? keychain.remove("accessToken")
    }
}
