//
//  ZMusicListTVC.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZMusicListTVC: ZBaseTVC {
    
    private var viewMain: UIView?
    private var imageIcon: UIImageView?
    private var lbName: UILabel?
    private var lbSinger: UILabel?
    private var imgLine: UIView?
    
    public let imageSize: CGFloat = 60
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.setViewFrame()
    }
    override func innerInit() {
        super.innerInit()
        self.contentView.backgroundColor = UIColor.clear
        
        self.viewMain = UIView()
        self.viewMain?.backgroundColor = .clear
        self.contentView.addSubview(self.viewMain!)
        
        self.imageIcon = UIImageView()
        self.viewMain?.addSubview(self.imageIcon!)
        
        self.lbName = UILabel()
        self.lbName?.textColor = UIColor.white
        self.lbName?.numberOfLines = 1
        self.lbName?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.viewMain?.addSubview(self.lbName!)
        
        self.lbSinger = UILabel()
        self.lbSinger?.textColor = UIColor.white
        self.lbSinger?.numberOfLines = 1
        self.lbSinger?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.viewMain?.addSubview(self.lbSinger!)
        
        self.imgLine = UIView()
        self.imgLine?.backgroundColor = UIColor.gray
        self.viewMain?.addSubview(self.imgLine!)
        
        self.setViewFrame()
    }
    func setViewFrame() {
        self.viewMain?.snp.removeConstraints()
        self.viewMain?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.edges.equalTo(self!.contentView).inset(UIEdgeInsets.zero)
            }
        })
        self.imageIcon?.snp.removeConstraints()
        self.imageIcon?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.height.equalTo(self!.imageSize)
                make.top.left.equalTo(self!.viewMain!).offset(self!.space)
            }
        })
        self.lbName?.snp.removeConstraints()
        self.lbName?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(self!.lbH)
                make.top.equalTo(self!.viewMain!.snp.top).offset(self!.space)
                make.left.equalTo(self!.imageIcon!.snp.right).offset(self!.space)
                make.right.equalTo(self!.viewMain!.snp.right).offset(self!.space)
            }
        })
        self.lbSinger?.snp.removeConstraints()
        self.lbSinger?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(self!.lbH)
                make.top.equalTo(self!.lbName!.snp.bottom).offset(self!.space)
                make.left.equalTo(self!.imageIcon!.snp.right).offset(self!.space)
                make.right.equalTo(self!.viewMain!.snp.right).offset(self!.space)
            }
        })
        self.imgLine?.snp.removeConstraints()
        self.imgLine?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(0.5)
                make.left.right.equalTo(self!.viewMain!).offset(0)
                make.bottom.equalTo(self!.viewMain!.snp.bottom).offset(0)
            }
        })
    }
    /// 设置数据模型
    func setCellData(model: ZModelMusic?) {
        if let model = model {
            self.imageIcon?.image = UIImage(named: model.musicIcon!)
            self.lbName?.text = model.musicName
            self.lbSinger?.text = model.singer
        }
    }
}
