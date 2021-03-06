//
//  ZLyricLabel.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZLyricLabel: UILabel {

    /// 播放进度
    var progress: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// 设置颜色
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.green.set()
        
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * progress, height: rect.size.height)
        
        textColor = .white
        
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    }

}
