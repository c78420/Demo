//
//  String+AESHelper.swift
//  InformationSecurity
//
//  Created by Tony Huang (黃崇漢) on 2018/6/2.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation
import RNCryptor

extension String {
    func decryptWith(key: String) -> String? {
        guard let decryptedData = decryptAsDataWith(key: key) else {
            return nil
        }
        
        return String(data: decryptedData, encoding: .utf8)
    }
    func decryptAsDataWith(key: String) -> Data? {
        guard let encryptedData = Data(base64Encoded: self) else {
            return nil
        }
        
        guard let decryptedData = try? RNCryptor.decrypt(data: encryptedData, withPassword: key) else {
            print("Fail to decrypt.")
            
            return nil
        }
        
        return decryptedData
    }
    func jsonStringToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func encryptWith(key: String) -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: key)
        return encryptedData.base64EncodedString()
    }
}
