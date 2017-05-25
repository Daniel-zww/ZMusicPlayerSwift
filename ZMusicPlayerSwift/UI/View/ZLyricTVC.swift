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
            if self.progress <= 0 {
                self.lbLyric?.font = UIFont.systemFont(ofSize: 15)
            } else {
                self.lbLyric?.font = UIFont.systemFont(ofSize: 17)
            }
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
        self.lbLyric?.textColor = UIColor.blue
        self.lbLyric?.numberOfLines = 1
        self.lbLyric?.lineBreakMode = .byTruncatingTail
        self.lbLyric?.font = UIFont.systemFont(ofSize: 15)
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
    /// 设置数据模型
    func setCellData(model: ZModelLyric?) {
        if let model = model {
            self.lbLyric?.text = model.lyricText
        }
    }

}
