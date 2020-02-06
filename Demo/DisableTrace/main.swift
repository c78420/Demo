//
//  main.swift
//  InformationSecurity
//
//  Created by Tony Huang (黃崇漢) on 2018/6/3.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation
import UIKit

autoreleasepool {
    // 再啟動前先檢查如果是 release 在 Trace 關閉程式
    disableTrace()
    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(
                to: UnsafeMutablePointer<Int8>.self,
                capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(AppDelegate.self) //Or your class name
    )
    
}
