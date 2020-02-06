//
//  CityCollectionViewCell.swift
//  tutorial
//
//  Created by Evgenii Trapeznikov on 1/7/19.
//  Copyright © 2019 Evgenii Trapeznikov. All rights reserved.
//

import UIKit

private enum State {
    case expanded
    case collapsed
 
    var change: State {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}

class CityCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    private let cornerRadius: CGFloat = 6
    
    static let cellSize = CGSize(width: 250, height: 350)
    static let identifier = "CityCollectionViewCell"
    
    @IBOutlet weak var cityTitle: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var collectionView: UICollectionView?
    private var index: Int?
    
    private var initialFrame: CGRect?
    private var state: State = .collapsed
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }()
    
    private let popupOffset: CGFloat = (UIScreen.main.bounds.height - cellSize.height)/2.0
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        recognizer.delegate = self
        return recognizer
     
    }()
    
    private var animationProgress: CGFloat = 0
    
    override func awakeFromNib() {
        self.addGestureRecognizer(panRecognizer)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
    }
    
    func configure(with city: City, collectionView: UICollectionView, index: Int) {
        cityTitle.text = city.name
        cityImage.image = UIImage(named: city.image)
        descriptionLabel.text = city.description
        
        self.collectionView = collectionView
        self.index = index
    }
    
    @IBAction func close(_ sender: Any) {
        toggle()
    }
    
    func toggle() {
        switch state {
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }
    
    private func collapse() {
        guard let collectionView = self.collectionView, let index = self.index else { return }
     
        animator.addAnimations {
            self.descriptionLabel.alpha = 0
            self.closeButton.alpha = 0
     
            self.layer.cornerRadius = self.cornerRadius
            self.frame = self.initialFrame!
     
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x += 50
            }
     
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x -= 50
            }
     
            self.layoutIfNeeded()
        }
     
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = true
                collectionView.allowsSelection = true
            default:
                ()
            }
        }
     
        animator.startAnimation()
    }
    
    private func expand() {
        guard let collectionView = self.collectionView, let index = self.index else { return }
     
        animator.addAnimations {
            self.initialFrame = self.frame
     
            self.descriptionLabel.alpha = 1
            self.closeButton.alpha = 1
     
            self.layer.cornerRadius = 0
            self.frame = CGRect(x: collectionView.contentOffset.x, y:0 , width: collectionView.frame.width, height: collectionView.frame.height)
     
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) {
                leftCell.center.x -= 50
            }
     
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) {
                rightCell.center.x += 50
            }
     
            self.layoutIfNeeded()
        }
     
        animator.addCompletion { position in
            switch position {
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = false
                collectionView.allowsSelection = false
            default:
                ()
            }
        }
     
        animator.startAnimation()
    }
    
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            toggle()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            let translation = recognizer.translation(in: collectionView)
            var fraction = -translation.y / popupOffset
            if state == .expanded { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
            if animator.isReversed { fraction *= -1 }
        case .ended:
            let velocity = recognizer.velocity(in: self)
            let shouldComplete = velocity.y > 0
             
            if velocity.y == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
             
            switch state {
            case .expanded:
                if !shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            case .collapsed:
                if shouldComplete && !animator.isReversed { animator.isReversed = !animator.isReversed }
                if !shouldComplete && animator.isReversed { animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
}
