//
//  ZLyricTVC.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZLyricTVC: ZBaseTVC {

    private var lbLyric: ZLyricLabel?
    public var progress: CGFloat = 0 {
        didSet {
            self.lbLyric?.progress = self.progress
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.setViewFrame()
    }
    override func innerInit() {
        super.innerInit()
        self.contentView.backgroundColor = UIColor.clear
        
        self.lbLyric = ZLyricLabel()
        self.lbLyric?.textAlignment = .center
        self.lbLyric?.textColor = UIColor.white
        self.lbLyric?.numberOfLines = 1
        self.lbLyric?.lineBreakMode = .byTruncatingTail
        self.lbLyric?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.lbLyric!)
        
        self.setViewFrame()
    }
    func setViewFrame() {
        self.lbLyric?.snp.removeConstraints()
        self.lbLyric?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(self!.lbH)
                make.left.right.equalTo(self!.contentView).offset(self!.space)
                make.centerY.equalTo(self!.contentView)
            }
        })
    }
    /// 设置字体大小 
    func setLabelFontSize(size: CGFloat) {
        self.lbLyric?.font = UIFont.systemFont(ofSize: size)
    }
    /// 设置数据模型
    func setCellData(model: ZModelLyric?) {
        self.lbLyric?.text = model?.lyricText
    }

}
