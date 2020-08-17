//
//  ScrollView.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/5/31.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class ScrollView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height)
        
        view.addSubview(scrollView)
        
//        view.backgroundColor = .blue
//        view.addSubview(myScrollView(frame: view.bounds))
        
        scrollView.addSubview(myScrollView(frame: view.bounds))
        scrollView.addSubview(myScrollView(frame: CGRect(x: view.bounds.size.width, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)))
    }

}

class myScrollView: UIScrollView, UIScrollViewDelegate {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.image = UIImage(named: "0")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    
    var orientation: UIDeviceOrientation = .portrait
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        addSubview(imageView)
        
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        translatesAutoresizingMaskIntoConstraints = true
        
        delegate = self
        maximumZoomScale = 2.0
        minimumZoomScale = 1.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    @objc func rotated() {        
        let currentOrientation = UIDevice.current.orientation
        if (currentOrientation.isPortrait || currentOrientation.isLandscape) && currentOrientation.rawValue != orientation.rawValue {
            print("reset")
            orientation = currentOrientation
            DispatchQueue.main.async {
                self.zoomScale = 1.0
                self.imageView.frame = self.frame
                self.contentSize = self.frame.size
            }
        }
    }
}
