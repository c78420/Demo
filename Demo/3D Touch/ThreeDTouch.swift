//
//  ThreeDTouch.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/1.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ThreeDTouch: UIViewController, UIViewControllerPreviewingDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [String] = ["iPhone", "iPad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 3D Touch
        let item = UIApplicationShortcutItem(type: "com.my.demo.project.gotoSecond", localizedTitle: "Second", localizedSubtitle: "go to Second View", icon: UIApplicationShortcutIcon(type: .search), userInfo: nil)
        UIApplication.shared.shortcutItems = [item]
        
        // Check device support 3D Touch
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: self.myView)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // Peek
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "peek")
        
        return vc
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "pop")
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.tableData[indexPath.row]
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: cell)
        }
        
        return cell
    }
    
    // 力道
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, traitCollection.forceTouchCapability == .available {
            print("力道： \(touch.force)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
