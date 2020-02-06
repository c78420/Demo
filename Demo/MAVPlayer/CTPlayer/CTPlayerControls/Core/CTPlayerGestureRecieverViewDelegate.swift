//
//  CTPlayerGestureRecieverViewDelegate.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/14.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Foundation

protocol CTPlayerGestureRecieverViewDelegate: AnyObject {
    
    /// Pinch was recognized
    func didPinch(with scale: CGFloat)
    
    /// Tap was recognized
    func didTap(at point: CGPoint)
    
    /// Double tap was recognized
    func didDoubleTap(at point: CGPoint)
    
    /// Pan was recognized
    func didPan(with translation: CGPoint, initially at: CGPoint)
}
