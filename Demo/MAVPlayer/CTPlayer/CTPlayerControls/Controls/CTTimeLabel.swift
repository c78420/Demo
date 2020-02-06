//
//  CTTimeLabel.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CTTimeLabel: UILabel {
    
    func update(toTime: TimeInterval) {
        let component =  self.dateComponentFrom(time: toTime)
        if let hour = component.hour ,
            let min = component.minute ,
            let sec = component.second {
            
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            text =  NSString(format: "%@%02d:%02d", fix, min, sec) as String
        }
        else {
            text =  "-:-"
        }
    }
    
    fileprivate func dateComponentFrom(time: TimeInterval) -> DateComponents {
        let date1 = Date()
        let date2 = Date(timeInterval: time, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }

}
