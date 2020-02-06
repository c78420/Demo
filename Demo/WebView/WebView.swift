//
//  WebView.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/1/21.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import WebKit

class WebView: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        NotificationCenter.default.addObserver(forName: UIWindow.didBecomeVisibleNotification, object: nil, queue: OperationQueue.main) { (notification) in
            print("播放")
        }
        
        NotificationCenter.default.addObserver(forName: UIWindow.didBecomeHiddenNotification, object: nil, queue: OperationQueue.main) { (notification) in
            print("结束")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myURL = URL(string:"https://www.chinatimes.com/adevent/video/anvato.aspx?aid=20190117003691&cid=261413")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
