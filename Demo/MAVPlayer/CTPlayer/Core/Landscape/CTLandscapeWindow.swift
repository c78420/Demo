//
//  CTLandscapeWindow.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/22.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CTLandscapeWindow: UIWindow {
    
    /// Shared Instance
    @objc static let shared =  CTLandscapeWindow(frame: .zero)
    
    /// Player view
    weak var currentPlayView: CTPlayerView!
    
    /// Original view
    weak var originalPlayView: UIView!
    
    /// Original Window
    weak var originalWindow: UIWindow!
    
    /// Original Window
    var originalFrame: CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// Setup
    func makeKey(playerView: CTPlayerView?) {
        if self.isKeyWindow {
            return
        }
        guard let playerView = playerView else {
            return
        }
        guard let full = UIStoryboard.init(name: "CTLandscape", bundle: nil).instantiateViewController(withIdentifier: "FullScreenViewController") as? FullScreenViewController else {
            return
        }
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        currentPlayView = playerView
        originalPlayView = playerView.superview
        originalWindow = window
        self.rootViewController = full
        
        currentPlayView.isTransitioning = true
        
        originalFrame = originalWindow.convert(originalPlayView.bounds, from: originalPlayView)
        currentPlayView.translatesAutoresizingMaskIntoConstraints = true
        currentPlayView.frame = originalFrame
        originalWindow.addSubview(currentPlayView)
        
        UIView.animate(withDuration: 0.3, animations: {
            let height = self.originalWindow.bounds.height
            let width = self.originalWindow.bounds.width
            let maxValue = max(width, height)
            let minValue = min(width, width)
            
            self.currentPlayView.bounds = CGRect(origin: .zero, size: CGSize(width: maxValue, height: minValue))
            self.currentPlayView.center = CGPoint(x: minValue * 0.5, y: maxValue * 0.5)
            self.currentPlayView.transform = CGAffineTransform(rotationAngle: .pi/2)
        }) { (complete) in
            self.layout(view: self.currentPlayView, into: full.view)
            self.makeKeyAndVisible()
        }
    }
    
    /// Landscape action
    func landscapeLayout() {
        self.frame = UIScreen.main.bounds
        self.rootViewController?.view.frame = UIScreen.main.bounds
    }
    
    /// Portrait action
    func portraitLayout() {
        currentPlayView.translatesAutoresizingMaskIntoConstraints = true
        
        let height = originalWindow.bounds.height
        let width = originalWindow.bounds.width
        let maxValue = max(width, height)
        let minValue = min(width, width)
        
        currentPlayView.bounds = CGRect(origin: .zero, size: CGSize(width: maxValue, height: minValue))
        currentPlayView.center = CGPoint(x: minValue * 0.5, y: maxValue * 0.5)
        currentPlayView.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        originalWindow.addSubview(currentPlayView)
        
        self.makeDisable()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.currentPlayView.bounds = CGRect(origin: .zero, size: self.originalFrame.size)
            self.currentPlayView.center = CGPoint(x: self.originalFrame.origin.x + self.originalFrame.size.width * 0.5,
                                                  y: self.originalFrame.origin.y + self.originalFrame.size.height * 0.5)
            self.currentPlayView.transform = CGAffineTransform.identity
        }) { (complete) in
            if let current = self.currentPlayView, let original = self.originalPlayView {
                current.isTransitioning = false
                self.layout(view: current, into: original)
                current.updateFullscreen(false)
            }
        }
    }
    
    func makeDisable() {
        self.rootViewController = nil
        DispatchQueue.main.async { [unowned self] in
            self.isHidden = true
        }
    }
    
    func layout(view: UIView, into: UIView? = nil) {
        guard let into = into else {
            return
        }
        view.transform = CGAffineTransform.identity
        into.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: into.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: into.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: into.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: into.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeKey() {
        super.becomeKey()
        self.backgroundColor = UIColor.clear
    }
    
    /// Detection layout orientation change
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.isKeyWindow {
            return
        }
        
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            self.landscapeLayout()
            break
        case .portrait:
//            self.portraitLayout()
            break
        default:
            break
        }
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
}
