//
//  WebViewController.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var link: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
        if let urlString = self.link, let url = URL(string: urlString) {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
