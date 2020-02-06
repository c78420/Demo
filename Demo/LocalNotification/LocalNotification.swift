//
//  LocalNotification.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/18.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class LocalNotification: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickCreateNotificationBtn(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "title：測試本地通知"
        content.subtitle = "subtitle：測試本地通知"
        content.body = "body：測試本地通知"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        /* Trigger
         UNTimeIntervalNotificationTrigger 每幾秒發送
         UNCalendarNotificationTrigger 指定日期發送
         UNLocationNotificationTrigger 當靠近某個位置時觸發
         UNPushNotificationTrigger 從後台發送
         */
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
    @IBAction func onClickCreateNotificationWithImageBtn(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "title：測試本地通知"
        content.subtitle = "subtitle：法蘭克"
        content.body = "body：法蘭克的IOS世界"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        // 設置通知的圖片
        let imageURL: URL = Bundle.main.url(forResource: "channelLogo_small@3x", withExtension: "png")!
        let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
        content.attachments = [attachment]
        
        // 設置點擊通知後取得的資訊
        content.userInfo = ["link" : "https://www.google.com.tw/"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
}
