//
//  SwiftUIVC.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/5.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import SwiftUI

class SwiftUIVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showSwiftUI(_ sender: Any) {
        self.navigationController?.pushViewController(UIHostingController(rootView: ContentView(contentDatas: contentDatas)), animated: true)
    }
}
