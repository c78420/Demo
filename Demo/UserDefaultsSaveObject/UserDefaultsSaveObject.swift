//
//  UserDefaultsSaveObject.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/21.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class UserDefaultsSaveObject: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = Test()
        test.myInt = 1234
        
        let encode = try? JSONEncoder().encode(test)
        UserDefaults.standard.set(encode, forKey: "Test")
        
        if let data = UserDefaults.standard.data(forKey: "Test") {
            let decode = try? JSONDecoder().decode(Test.self, from: data)
            
            print("decode data: \(decode?.myInt)")
        }
    }
}

class Test: Codable {
    var myInt: Int?
}
