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
        
        self.lbLyric = ZLyricLabel()
        self.lbLyric?.textColor = UIColor.white
        self.lbLyric?.numberOfLines = 1
        self.lbLyric?.lineBreakMode = .byTruncatingTail
        self.lbLyric?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(self.lbLyric!)
    }
    func setViewFrame() {
        self.lbLyric?.snp.removeConstraints()
        self.lbLyric?.snp.makeConstraints({[weak self] (maker) in
            if self != nil {
                maker.height.equalTo(self!.lbH)
                maker.left.right.equalTo(self!.contentView).offset(self!.space)
                maker.centerY.equalTo(self!.contentView)
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
