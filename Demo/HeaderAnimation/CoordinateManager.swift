//
//  CoordinateManager.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/12/9.
//  Copyright © 2018 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CoordinateManager {
    fileprivate var headerView: UIView?
    
    fileprivate var headerViewHeight:CGFloat = 0
    fileprivate var headerViewWidth:CGFloat = 0
    fileprivate var newOriginY:CGFloat = 0
    
    init(scrollView: UIScrollView, header: UIView?) {
        if let header = header {
            headerView = header
            headerViewHeight = header.frame.height
            headerViewWidth = header.frame.width
            newOriginY = header.frame.origin.y - headerViewHeight
            header.frame = CGRect(x: header.frame.origin.x, y: newOriginY, width: headerViewWidth, height: headerViewHeight)
            
            scrollView.contentInset = UIEdgeInsets(top: header.frame.height, left: 0, bottom: 0, right: 0)
            scrollView.addSubview(header)
        } else {
            headerViewHeight = 0
            headerViewWidth = 0
            newOriginY = 0
        }
    }
    
    func scrolledDetection(_ scrollView: UIScrollView) {
        let overScroll = scrollView.bounds.origin.y + scrollView.contentInset.top
        if overScroll < 0 {
            self.belowDrawing(overScroll)
        } else if overScroll > 0 {
            self.aboveDrawing(overScroll)
        } else {
            self.resetDraw()
        }
    }
    
    fileprivate func belowDrawing(_ overScroll: CGFloat) {
        if let header = headerView {
            header.frame = CGRect(x: overScroll / 2, y: newOriginY + overScroll,
                                  width: headerViewWidth - overScroll, height: headerViewHeight - overScroll)
        }
    }
    
    fileprivate func aboveDrawing(_ overScroll: CGFloat) {
    }
    
    fileprivate func resetDraw() {
        if let header = headerView {
            header.frame = CGRect(x: 0, y: newOriginY, width: headerViewWidth, height: headerViewHeight)
        }
    }
}
