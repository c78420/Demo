//
//  SVG.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/5/18.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import WebKit

class SVG: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView = WKWebView(frame: CGRect(x: 0, y: 100, width: 400, height: 400))
        webView.backgroundColor = .black
        webView.layer.borderColor = UIColor.black.cgColor
        webView.layer.borderWidth = 1
        bgView.addSubview(webView)
        
        guard let path: String = Bundle.main.path(forResource: "swipe_left", ofType: "svg") else {
            print("=====> get path fail")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let myRequest = URLRequest(url: url)
        
        webView.load(myRequest)
    }

}
