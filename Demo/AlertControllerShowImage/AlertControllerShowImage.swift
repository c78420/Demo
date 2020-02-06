//
//  UIAlertControllerShowImage.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/5/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class AlertControllerShowImage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Air Drop", message: "Share photo", preferredStyle: .alert)
        
        guard let image = UIImage(named: "channelLogo_small") else { return }
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        var ratio: CGFloat
        if imgSize.height > imgSize.width {
            ratio = maxSize.height / imgSize.height
        } else {
            ratio = maxSize.width / imgSize.width
        }
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        let scaledImage = resizeImage(image: image, targetSize: scaledSize)
        
        let imageAtion = UIAlertAction(title: "", style: .default, handler: nil)
        imageAtion.isEnabled = false
        imageAtion.setValue(scaledImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(imageAtion)
        
        let decline = UIAlertAction(title: "Decline", style: .cancel, handler: nil)
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alert.addAction(decline)
        alert.addAction(accept)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
