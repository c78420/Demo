//
//  Localization.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/12/27.
//  Copyright © 2018 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Localization: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\("title".localize())")
        print("\("test1_title".localize())")
        print("\("test2_title".localize())")
        print("===========================")
        
        Localize.shared.type = .custom(tableName: "test1_Localizable")
        
        print("\("title".localize())")
        print("\("test1_title".localize())")
        print("\("test2_title".localize())")
        print("===========================")
        
        Localize.shared.type = .custom(tableName: "test2_Localizable")
        
        print("\("title".localize())")
        print("\("test1_title".localize())")
        print("\("test2_title".localize())")
        print("===========================")
        
        Localize.shared.type = .system
        
        print("\("title".localize())")
        print("\("test1_title".localize())")
        print("\("test2_title".localize())")
        print("===========================")
    }

}
