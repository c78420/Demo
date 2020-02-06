//
//  AppDelegate.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/5/21.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import UserNotifications

// Swift 自動生成 main
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        
        // 代理 UNUserNotificationCenterDelegate，這麼做可讓 App 在前景狀態下收到通知
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let viewController = (window?.rootViewController as! UINavigationController).viewControllers.last as? CoreSpotlight {
            viewController.restoreUserActivityState(userActivity)
        }
        
        return true
    }

    // 裝置鎖定狀態
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("applicationProtectedDataDidBecomeAvailable")
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        print("applicationProtectedDataWillBecomeUnavailable")
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let navigation = self.window?.rootViewController as? UINavigationController {
            if shortcutItem.type == "com.my.demo.project.gotoFirst" {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "PageAnimation")
                navigation.pushViewController(vc, animated: true)
            }
            else if shortcutItem.type == "com.my.demo.project.gotoSecond" {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "PullRefresh")
                navigation.pushViewController(vc, animated: true)
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if window == CTLandscapeWindow.shared {
            return .landscape
        }
        else {
            return .portrait
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 在前景收到通知時所觸發的 function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前景收到通知...")
        completionHandler([.badge, .sound, .alert])
    }
    
    // 點擊通知觸發的事件
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content: UNNotificationContent = response.notification.request.content
        
        completionHandler()
        
        // 取出userInfo的link並開啟Facebook
        let requestUrl = URL(string: content.userInfo["link"]! as! String)
        UIApplication.shared.open(requestUrl!, options: [:], completionHandler: nil)
    }
}

