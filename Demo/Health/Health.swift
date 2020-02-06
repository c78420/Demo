//
//  Health.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/27.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import HealthKit

class Health: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getHealthKitPermission()
    }
    
    @IBAction func click(_ sender: Any) {
        self.textField.resignFirstResponder()
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) else {
            fatalError("*** This method should never fail ***")
        }
        
        let date = Date()
        
        guard let height = self.textField.text?.components(separatedBy: " ").first, let value = Double(height) else {
            print("=====> return")
            return
        }
        
        let quantity = HKQuantity(unit: HKUnit.meter(), doubleValue: value)
        
        let sample = HKQuantitySample(type: sampleType, quantity: quantity, start: date, end: date)
        
        HKHealthStore().save(sample) { (success, error) in
            if !success {
                print("=====> fail")
            }
            else {
                print("=====> success")
            }
        }
    }
    
    func getHealthKitPermission() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        let healthStore = HKHealthStore()
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .height)!,
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                
            }
            else {
                self.getHeight()
            }
        }
    }
    
    func getHeight() {
        let startDate = Date.distantPast
        let endDate = Date(timeIntervalSinceNow: 86400)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) else {
            fatalError("*** This method should never fail ***")
        }
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription ?? "")");
            }
            
            DispatchQueue.main.async {
                var heightString = ""
                
                let sample = samples.first
                
                if let meters = sample?.quantity.doubleValue(for: HKUnit.meter()) {
                    let formatHeight = LengthFormatter()
                    formatHeight.isForPersonHeightUse = true
                    heightString = formatHeight.string(fromMeters: meters)
                }
                
                self.textField.text = heightString
            }
        }
        
        HKHealthStore().execute(query)
    }

}
