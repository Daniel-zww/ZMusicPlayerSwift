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
        willSet {
            self.setNeedsDisplay()
        }
    }
    /// 设置颜色
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.green.set()
        let fillRect = CGRect(x: 0, y: 0, width: rect.size.width * self.progress, height: rect.size.height)
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    }

}
