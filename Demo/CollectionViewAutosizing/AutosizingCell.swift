//
//  AutosizingCell.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/6/8.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class AutosizingCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        self.widthConstraint.constant = screenWidth - (2 * 12)
    }
}
