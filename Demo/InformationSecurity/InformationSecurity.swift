//
//  InformationSecurity.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/8.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class InformationSecurity: UIViewController {
    
    // 加解密用的 key 不要用明碼顯示在程式中，透過程式碼運算出 key 值，能夠混淆駭客
    var primaryKey: String = {
//        return "1234"
//        return String( 12 * 100 + 34 )
        let result = String( ( "4" + String( 4 * 8 ) + "1" ).reversed() )
        return result
    }()
    
    @IBAction func getData(_ sender: Any) {
        // key 跟 URL 解密
        guard let packageKey = "AwGVDV/C1E7rwuy+Do+sENWgi2jIwq7kHklJeWHnGkVl+W12v0V2ybD7zu999QcTtU46pyiPBSOUeLgW84UeN67AG754y3J93lUve7/C3HV+HXJkun/3qvv/XqaJanNixRo=".decryptWith(key: primaryKey) else {
            assertionFailure("Fail to decrypt packageKey.")
            return
        }
        guard let passwordKeyPrefix = "AwF89Uht7TcpDCCTMGmASGwXSe29RU5nKpzisNyfBBC5khBTfVGh3aJOZTUucHBOlm1OrDQj8Roi9lsOvIL1wfZqSyYRnre6BgFRdMvWIDPEnA==".decryptWith(key: primaryKey) else {
            assertionFailure("Fail to decrypt passwordKey.")
            return
        }
        guard let urlString = "AwE1Gt+cVlNzpvjcctEXnSFvMdyFO4oTqTmAuaa42HwAzxCAyq3ymriJEiIEn+gOs7/B4mC5fUplby/zuccin7KayEgalBbA25tf7VmjhdfpohTXC3g7Ax69ycflXqW6/V7G8d0BDZ7TvJZrYYEunt7uKdImrzlMTT8j+6JxVkxufQ==".decryptWith(key: primaryKey) else {
            assertionFailure("Fail to decrypt urlString.")
            return
        }
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Invalid URL.")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            var encryptedContent: String
            
            if let error = error {
                print("Download Fail: \(error)")
                
                encryptedContent = "AwEiP1ygP0ahAzumpcIiu3O4XkGZHUvF+hle2Yfc997fNtXtUwFmBkOFJydNq1gHJhWrKKRATVS2BniojhXbb7KoSXtOR7WCVhW7FukuVF5ACvxlb6GV7nzUY3EkktrDrgDYxsm9yv1MXv9Wwvsc11ubM5DNcJS7uUqruhSZC2FSzGhUVk37bsKub4bXiAZ6bPL9HYcezzYnT4sICg3KZ/MMiSxHUkbD9EJ+uHhltRur2wSYX4zxWkKZTXWETUduwAzCCMBLBuMFHx17QeZE12Z+xocU+pB0YoUGrBUUGPMsZELsIliHsaCN8AOPGAuH0f4="
            } else {
                guard let data = data else {
                    assertionFailure("Recetive data is nil.")
                    return
                }
                guard let encrypted = String(data: data, encoding: .utf8) else {
                    assertionFailure("Fail to convert data to string.")
                    return
                }
                
                encryptedContent = encrypted
            }
            
            print("encryptedContent: \(encryptedContent)")
            
            // Decrypt the package
            guard let decryptedData = encryptedContent.decryptAsDataWith(key: packageKey) else {
                print("Fail to decrypt package.")
                return
            }
            
            // JSON decod to object
            let decorder = JSONDecoder()
            guard let package = try? decorder.decode(SamplePackage.self, from: decryptedData) else {
                assertionFailure("Fail to decorde as SamplePackage struct.")
                return
            }
            
            // password key 是 Prefix key + timestamp 組成，會根據 timestamp 每次 password 加密之後的直都會不一樣
            let encryptedPW = package.pw
            let pwKey = passwordKeyPrefix + package.timestamp
            guard let decryptedPW = encryptedPW.decryptWith(key: pwKey) else {
                assertionFailure("Fail to decorde pw.")
                return
            }
            
            print("decryptedPW: \(decryptedPW)")
        }
        task.resume()
    }
    
    // 把重要的 key 或 URL 在做加密
    @IBAction func encryptTest(_ sender: Any) {
        let urlString = "http://class.softarts.cc/AppSecurity/encryptData.json"
        let packageKey = "zaq1xsw2cde3vfr4"
        let passwordKeyPrefix = "1qaz2wsx"
        
        let encryptedPackageKey = packageKey.encryptWith(key: primaryKey)
        print("encryptedPackageKey: \(encryptedPackageKey)")
        let encryptedPasswordKey = passwordKeyPrefix.encryptWith(key: primaryKey)
        print("encryptedPasswordKey: \(encryptedPasswordKey)")
        let encryptedUrlString = urlString.encryptWith(key: primaryKey)
        print("encryptedUrlString: \(encryptedUrlString)")
    }
}

struct SamplePackage: Codable {
    var username: String
    var pw: String
    var timestamp: String
}
