//
//  CTPlayerRenderingView.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/2/13.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AVKit

class CTPlayerRenderingView: UIView {

    /// CTPlayerLayer instance used to render player content
    var renderingLayer: AVPlayerLayer!
    
    /// CTPlayerView instance being rendered by renderingLayer
    weak var player: CTPlayerView!

    /// Constructor
    init(with player: CTPlayerView) {
        super.init(frame: CGRect.zero)
        self.player = player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if renderingLayer == nil {
            renderingLayer = AVPlayerLayer.init(player: player.player)
            layer.addSublayer(renderingLayer)
        }
        
        renderingLayer.frame = bounds
    }
    
}
