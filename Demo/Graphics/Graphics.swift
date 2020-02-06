//
//  Graphics.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/10.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Graphics: UIViewController {

    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            if counterView.counter < 8 {
                counterView.counter += 1
            }
        }
        else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            //hide Graph
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion:nil)
        }
        else {
            //show Graph
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
            
            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func setupGraphDisplay() {
        
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        
        //  1 - replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        
        //  3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        // 4 - setup date formatter and calendar
        let today = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
        // 5 - set up the day name labels with correct days
        for i in 0...maxDayIndex {
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
                let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
                label.text = formatter.string(from: date)
            }
        }
    }
}
