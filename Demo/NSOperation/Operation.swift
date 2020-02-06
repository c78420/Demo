//
//  Operation.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/4.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Downloader {
    
    class func downloadImageWithURL(url: String) -> UIImage! {
        
        let data = try! Data(contentsOf: URL(string: url)!)
        return UIImage(data: data)
    }
}

class Operation: UIViewController {
    
    let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                     "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                     "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                     "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg"]

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func clearImage() {
        self.imageView1.image = nil
        self.imageView2.image = nil
        self.imageView3.image = nil
        self.imageView4.image = nil
    }
    
    @IBAction func didClickOnStart(_ sender: Any) {
        self.clearImage()
        
        let queue = OperationQueue()
        
        queue.addOperation { () -> Void in
            let img1 = Downloader.downloadImageWithURL(url: self.imageURLs[0])

            OperationQueue.main.addOperation({
                self.imageView1.image = img1
            })
        }
        
        let operation2 = BlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(url: self.imageURLs[1])
            OperationQueue.main.addOperation({
                self.imageView2.image = img2
            })
        })
        
        operation2.completionBlock = {
            print("Operation 2 completed")
        }
        
        let operation3 = BlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(url: self.imageURLs[2])
            OperationQueue.main.addOperation({
                self.imageView3.image = img3
            })
        })
        
        operation3.completionBlock = {
            print("Operation 3 completed")
        }
        
        let operation4 = BlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(url: self.imageURLs[3])
            OperationQueue.main.addOperation({
                self.imageView4.image = img4
            })
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed")
        }
        
        operation3.addDependency(operation2)
        operation4.addDependency(operation3)
        
        queue.addOperation(operation2)
        queue.addOperation(operation3)
        queue.addOperation(operation4)
    }
    
}
