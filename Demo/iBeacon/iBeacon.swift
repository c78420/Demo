//
//  iBeacon.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/20.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import CoreLocation

class iBeacon: UIViewController {
    
    @IBOutlet weak var distance: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        monitorBeacons()
    }
    
    func monitorBeacons() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            let proximityUUID = UUID(uuidString: "B0702880-A295-A8AB-F734-031A98A512DE")
            let beaconId = "deeplove"
            let region = CLBeaconRegion(uuid: proximityUUID!, identifier: beaconId)
            locationManager.startMonitoring(for: region)
            locationManager.startRangingBeacons(satisfying: region.beaconIdentityConstraint)
        }
    }
    
}

extension iBeacon: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter region")
        
        let content = UNMutableNotificationContent()
        content.title = "注意"
        content.subtitle = "小明就在你身邊"
        content.badge = 1
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        if CLLocationManager.isRangingAvailable() {
            locationManager.startRangingBeacons(satisfying: (region as! CLBeaconRegion).beaconIdentityConstraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit region")
        
        locationManager.stopRangingBeacons(satisfying: (region as! CLBeaconRegion).beaconIdentityConstraint)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons[0]
            print(nearestBeacon.uuid, nearestBeacon.major, nearestBeacon.minor)
            switch nearestBeacon.proximity {
            case .immediate:
                self.distance.text = "immediate"
            case .near:
                self.distance.text = "near"
            case .far:
                self.distance.text = "far"
            case .unknown:
                self.distance.text = "unknown"
            @unknown default:
                self.distance.text = "@unknown default"
            }
        }
    }
}
