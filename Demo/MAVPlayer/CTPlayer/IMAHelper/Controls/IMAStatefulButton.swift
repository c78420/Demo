//
//  IMAStatefulButton.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/23.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

@IBDesignable
class IMAStatefulButton: UIButton {

    @IBInspectable public var activeImage: UIImage? = nil {
        didSet {
            setImage(activeImage, for: .normal)
        }
    }
    @IBInspectable public var inactiveImage: UIImage? = nil {
        didSet {
            setImage(inactiveImage, for: .normal)
        }
    }
    
    func set(active: Bool) {
        if active {
            setImage(activeImage, for: .normal)
        }
        else {
            setImage(inactiveImage, for: .normal)
        }
    }
}
