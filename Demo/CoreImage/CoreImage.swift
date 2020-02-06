//
//  CoreImage.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/26.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

// CIFilter https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIColorClamp

import UIKit

class CoreImage: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = imageView?.image, let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return
        }
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        
        if let sepiaOutput = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            exposureFilter?.setValue(1, forKey: kCIInputEVKey)
            
            if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let cgimgresult = context.createCGImage(exposureOutput, from: exposureOutput.extent)
                let result = UIImage(cgImage: cgimgresult!)
                imageView?.image = result
            }
        }
        else {
            print("image filtering failed")
        }
    }

}
