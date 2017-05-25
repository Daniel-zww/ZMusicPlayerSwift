//
//  ZMusicViewController.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 播放VC
class ZMusicViewController: ZBaseViewController {
    
    /// 歌词的占位背景视图引用
    var visualEffectView: UIVisualEffectView?
    /// 背景图片
    var backImageView: UIImageView?
    /// 顶部
    var topView: UIView?
    /// 底部
    var bottomView: UIView?
    /// 中间
    var middleView: UIView?
    /// 歌词的占位背景视图
    var lrcBackView: UIScrollView?
    /// 歌手头像
    var iconImageView: UIImageView?
    /// 歌曲名称
    var songNameLabel: UILabel?
    /// 歌手名称
    var singerNameLabel: UILabel?
    /// 歌曲总时长
    var totalTimeLabel: UILabel?
    /// 播放的歌词
    var lrcLabel: ZLyricLabel?
    /// 歌曲已经播放的时长
    var costTimeLabel: UILabel?
    /// 进度条
    var progressSlider: UISlider?
    /// 播放暂停按钮
    var btnPlayOrPause: UIButton?
    /// 上一首
    var btnPre: UIButton?
    /// 下一首
    var btnNext: UIButton?
    /// 关闭
    var btnClose: UIButton?
    /// 分享
    var btnShare: UIButton?
    /// 显示歌词的VC
    var vcLyric: ZLyricViewController?
    /// 用来刷新界面的timer
    var updateTimer: Timer?
    /// 负责更新歌词的定时器
    var updateLrcLink: CADisplayLink?
    /// 单例模式
    public static var sharedInstance: ZMusicViewController {
        struct StaticMusicVC {
            static let instance: ZMusicViewController = ZMusicViewController()
        }
        return StaticMusicVC.instance
    }
    deinit {
        visualEffectView = nil
        lrcBackView = nil
        backImageView = nil
        topView = nil
        bottomView = nil
        middleView = nil
        iconImageView = nil
        songNameLabel = nil
        singerNameLabel = nil
        totalTimeLabel = nil
        lrcLabel = nil
        costTimeLabel = nil
        progressSlider = nil
        btnPlayOrPause = nil
        btnPre = nil
        btnNext = nil
        btnClose = nil
        vcLyric = nil
        updateTimer?.invalidate()
        updateTimer = nil
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
    /// 初始化控件
    override func innerInit() {
        super.innerInit()
        
        self.backImageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        self.view.addSubview(self.backImageView!)
        
        self.visualEffectView = UIVisualEffectView()
        self.view.addSubview(self.visualEffectView!)
        
        self.innerTopView()
        self.innerMiddleView()
        self.innerBottomView()
        self.setViewFrame()
    }
    func setViewFrame() {
        self.backImageView?.snp.removeConstraints()
        self.backImageView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.edges.equalTo(self!.view).inset(UIEdgeInsets.zero)
            }
        })
        self.visualEffectView?.snp.removeConstraints()
        self.visualEffectView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.edges.equalTo(self!.view).inset(UIEdgeInsets.zero)
            }
        })
        self.topView?.snp.removeConstraints()
        self.topView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(70)
                make.left.top.right.equalTo(self!.visualEffectView!).offset(0)
            }
        })
        self.bottomView?.snp.removeConstraints()
        self.bottomView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(100)
                make.left.right.equalTo(self!.visualEffectView!).offset(0)
                make.bottom.equalTo(self!.visualEffectView!.snp.bottom).offset(0)
            }
        })
        self.middleView?.snp.removeConstraints()
        self.middleView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.left.right.equalTo(self!.visualEffectView!).offset(0)
                make.top.equalTo(self!.topView!.snp.bottom).offset(0)
                make.bottom.equalTo(self!.bottomView!.snp.top).offset(0)
            }
        })
        let btnW = 55
        self.btnClose?.snp.removeConstraints()
        self.btnClose?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.equalTo(btnW)
                make.height.equalTo(40)
                make.left.equalTo(self!.topView!.snp.left).offset(10)
                make.top.equalTo(self!.topView!).offset(20)
            }
        })
        self.btnShare?.snp.removeConstraints()
        self.btnShare?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.equalTo(btnW)
                make.height.equalTo(40)
                make.right.equalTo(self!.topView!.snp.right).offset(-10)
                make.top.equalTo(self!.topView!).offset(20)
            }
        })
        self.songNameLabel?.snp.removeConstraints()
        self.songNameLabel?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(25)
                make.left.equalTo(self!.btnClose!.snp.left).offset(10)
                make.right.equalTo(self!.btnShare!.snp.right).offset(-10)
                make.top.equalTo(self!.topView!.snp.top).offset(25)
            }
        })
        self.singerNameLabel?.snp.removeConstraints()
        self.singerNameLabel?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(20)
                make.top.equalTo(self!.songNameLabel!.snp.bottom).offset(5)
                make.left.equalTo(self!.btnClose!.snp.left).offset(10)
                make.right.equalTo(self!.btnShare!.snp.right).offset(-10)
            }
        })
    }

}
extension ZMusicViewController {
    func innerTopView() {
        self.topView = UIView()
        self.visualEffectView?.contentView.addSubview(self.topView!)
        
        self.btnClose = UIButton(type: UIButtonType.custom)
        self.btnClose?.setImage(UIImage(named: "btn_back"), for: UIControlState.normal)
        self.btnClose?.setImage(UIImage(named: "btn_back"), for: UIControlState.highlighted)
        self.btnClose?.addTarget(self, action: #selector(btnCloseClick), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(self.btnClose!)
        
        self.btnShare = UIButton(type: UIButtonType.custom)
        self.btnShare?.setImage(UIImage(named: "more_icon"), for: UIControlState.normal)
        self.btnShare?.setImage(UIImage(named: "more_icon"), for: UIControlState.highlighted)
        self.btnShare?.addTarget(self, action: #selector(btnShareClick), for: UIControlEvents.touchUpInside)
        self.topView?.addSubview(self.btnShare!)
        
        self.songNameLabel = UILabel()
        self.songNameLabel?.textAlignment = .center
        self.songNameLabel?.textColor = .white
        self.songNameLabel?.font = UIFont.systemFont(ofSize: 17)
        self.songNameLabel?.text = "歌曲名称"
        self.topView?.addSubview(self.songNameLabel!)
        
        self.singerNameLabel = UILabel()
        self.singerNameLabel?.textAlignment = .center
        self.singerNameLabel?.textColor = .white
        self.singerNameLabel?.font = UIFont.systemFont(ofSize: 15)
        self.singerNameLabel?.text = "作者"
        self.topView?.addSubview(self.singerNameLabel!)
        
    }
    func innerMiddleView() {
        self.middleView = UIView()
        self.visualEffectView?.contentView.addSubview(self.middleView!)
    }
    func innerBottomView() {
        self.bottomView = UIView()
        self.visualEffectView?.contentView.addSubview(self.bottomView!)
    }
}
extension ZMusicViewController {
    @objc func btnCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func btnShareClick() {
        debugPrint("点击了分享")
    }
}
