//
//  RearCell.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/5/8.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Kingfisher

class RearCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
