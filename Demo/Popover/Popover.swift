//
//  Popover.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/19.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Popover: UIViewController, UIPopoverPresentationControllerDelegate, PopViewDelegate {

    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigationClick))
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @objc func navigationClick() {
        let pop = PopViewController()
        pop.modalPresentationStyle = .popover
        pop.popoverPresentationController?.delegate = self
        pop.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        pop.preferredContentSize = CGSize(width: 180, height: 120)
        pop.popoverPresentationController?.permittedArrowDirections = .up
        pop.delegate = self
        self.present(pop, animated: true, completion: nil)
    }

    @IBAction func popoverClick(_ sender: Any) {
        let pop = PopViewController()
        pop.modalPresentationStyle = .popover
        pop.popoverPresentationController?.delegate = self
        pop.popoverPresentationController?.sourceView = btn
        pop.popoverPresentationController?.sourceRect = btn.bounds
        pop.preferredContentSize = CGSize(width: 100, height: 100)
        pop.popoverPresentationController?.permittedArrowDirections = .down
        pop.delegate = self
        self.present(pop, animated: true, completion: nil)
    }
    
    func click() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
