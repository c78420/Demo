//
//  GCD.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/25.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class GCD: UIViewController {
    
    let task1 = {
        for i in 1...5 {
            print("Task1： \(i)")
        }
    }
    
    let task2 = {
        for i in 1...5 {
            print("Task2： \(i)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func mainClick(_ sender: Any) {
        DispatchQueue.main.async(execute: task1)
        DispatchQueue.main.async(execute: task2)
    }
    
    @IBAction func concurrentClick(_ sender: Any) {
        let concurrentQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
        concurrentQueue.async(execute: task1)
        concurrentQueue.async(execute: task2)
    }
    
    @IBAction func serialClick(_ sender: Any) {
        let serialQueue = DispatchQueue(label: "com.leo.serialQueue")
        serialQueue.async(execute: task1)
        serialQueue.async(execute: task2)
    }
    
    @IBAction func inactiveQueueClick(_ sender: Any) {
        let inactiveQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .initiallyInactive)
        
        inactiveQueue.async(execute: task1)
        inactiveQueue.async(execute: task2)
        
        inactiveQueue.activate()
    }
    
    @IBAction func dispatchGroupClick(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.tag == 1 {
                // 我们模拟两个耗时2秒和4秒的网络请求
                
                print("Group created")
                let group = DispatchGroup()
                group.enter()
                networkTask(label: "1", cost: 2, complete: {
                    group.leave()
                })
                
                group.enter()
                networkTask(label: "2", cost: 2, complete: {
                    group.leave()
                })
                
                group.wait(timeout: .now() + .seconds(4))
                
                group.notify(queue: .main, execute:{
                    print("All network is done")
                })
            }
            else if button.tag == 2 {
                let group = DispatchGroup()
                
                let queueBook = DispatchQueue(label: "book")
                print("start networkTask task 1")
                queueBook.async(group: group) {
                    sleep(2)
                    print("End networkTask task 1")
                }
                let queueVideo = DispatchQueue(label: "video")
                print("start networkTask task 2")
                queueVideo.async(group: group) {
                    sleep(2)
                    print("End networkTask task 2")
                }
                
                group.notify(queue: DispatchQueue.main) {
                    print("all task done")
                }
            }
        }
    }
    
    func networkTask(label:String, cost:UInt32, complete:@escaping ()->()){
        print("Start network Task task \(label)")
        DispatchQueue.global().async {
            sleep(cost)
            print("End networkTask task \(label)")
            DispatchQueue.main.async {
                complete()
            }
        }
    }
    
    @IBAction func dispatchWorkItemClick(_ sender: Any) {
        var number = 10
        
        let workItem = DispatchWorkItem {
            number += 5
        }
        
        workItem.perform()
        
        print("after perform number = \(number)")
        
        let queue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
        
        queue.async(execute: workItem)
        
        workItem.notify(queue: DispatchQueue.main) {
            print("notify number = \(number)")
        }
    }
    
    @IBAction func afterClick(_ sender: Any) {
        print("DispatchTime \(DispatchTime.now())")
        print("DispatchWallTime \(DispatchWallTime.now())")
        
        let deadline = DispatchTime.now() + 2.0
        
        NSLog("Start")
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            NSLog("End")
        }
    }
    
    @IBAction func dispatchSourceClick(_ sender: Any) {
        let timer = DispatchSource.makeTimerSource()
        
        timer.setEventHandler {
            //这里要注意循环引用，[weak self] in
            print("Timer fired at \(NSDate())")
        }
        
        timer.setCancelHandler {
            print("Timer canceled at \(NSDate())" )
        }
        
        timer.schedule(deadline: .now() + .seconds(1), repeating: 2.0, leeway: .microseconds(10))
        
        print("Timer resume at \(NSDate())")
        timer.activate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute:{
            timer.cancel()
        })
    }
    
    @IBAction func dispatchSemaphoreClick(_ sender: Any) {
        let semaphore = DispatchSemaphore(value: 2)
        let queue = DispatchQueue(label: "com.leo.concurrentQueue", qos: .default, attributes: .concurrent)
        
        queue.async {
            semaphore.wait()
            self.usbTask(label: "1", cost: 2, complete: {
                semaphore.signal()
            })
        }
        
        queue.async {
            semaphore.wait()
            self.usbTask(label: "2", cost: 2, complete: {
                semaphore.signal()
            })
        }
        
        queue.async {
            semaphore.wait()
            self.usbTask(label: "3", cost: 1, complete: {
                semaphore.signal()
            })
        }
    }
    
    func usbTask(label:String, cost:UInt32, complete:@escaping ()->()){
        NSLog("Start usb task%@",label)
        sleep(cost)
        NSLog("End usb task%@",label)
        complete()
    }
}
