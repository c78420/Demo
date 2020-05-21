//
//  StarTrail.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/5/3.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class StarTrail: UIViewController {
    
    lazy var particleEmitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.renderMode = .additive
        return emitter
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(handleTap))
        return gestureRecognizer
    }()
    
    let starParticle = StarParticle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func showStars() {
        particleEmitter.emitterCells = [starParticle]
        view.layer.addSublayer(particleEmitter)
    }
    
    @objc func handleTap(sender: UIPanGestureRecognizer) {
        particleEmitter.emitterPosition = sender.location(in: view)
        
        if sender.state == .ended {
            particleEmitter.lifetime = 0
        }
        else if sender.state == .began {
            showStars()
            particleEmitter.lifetime = 1.0
        }
    }
    
}

public class StarParticle: CAEmitterCell {
    
    public override init() {
        super.init()
        self.birthRate = 30
        self.lifetime = 1.0
        self.velocity = 100
        self.velocityRange = 50
        self.emissionLongitude = 90
        self.emissionRange = .pi
        self.spinRange = 5
        self.scale = 0.5
        self.scaleRange = 0.25
        self.alphaSpeed = -1
        self.contents = UIImage(named: "icons8-star-48")?.cgImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
