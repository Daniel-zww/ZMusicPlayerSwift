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
    private var visualEffectView: UIVisualEffectView?
    /// 背景图片
    private var backImageView: UIImageView?
    /// 顶部
    private var topView: UIView?
    /// 底部
    private var bottomView: UIView?
    /// 中间
    private var middleView: UIView?
    /// 歌词的占位背景视图
    private var lrcBackView: UIScrollView?
    /// 歌手头像
    private var iconImageView: UIImageView?
    /// 歌曲名称
    private var songNameLabel: UILabel?
    /// 歌手名称
    private var singerNameLabel: UILabel?
    /// 歌曲总时长
    private var totalTimeLabel: UILabel?
    /// 播放的歌词
    private var lrcLabel: ZLyricLabel?
    /// 歌曲已经播放的时长
    private var costTimeLabel: UILabel?
    /// 进度条
    private var progressSlider: UISlider?
    /// 播放暂停按钮
    private var btnPlayOrPause: UIButton?
    /// 上一首
    private var btnPre: UIButton?
    /// 下一首
    private var btnNext: UIButton?
    /// 关闭
    private var btnClose: UIButton?
    /// 显示歌词的VC
    private var vcLyric: ZLyricViewController?
    /// 用来刷新界面的timer
    private var updateTimer: Timer?
    /// 负责更新歌词的定时器
    private var updateLrcLink: CADisplayLink?
    /// 单例模式
    public static var sharedInstance: ZMusicViewController {
        struct StaticMusicVC {
            static let instance: ZMusicViewController = ZMusicViewController()
        }
        return StaticMusicVC.instance
    }
    deinit {
        self.visualEffectView = nil
        self.lrcBackView = nil
        self.backImageView = nil
        self.topView = nil
        self.bottomView = nil
        self.middleView = nil
        self.iconImageView = nil
        self.songNameLabel = nil
        self.singerNameLabel = nil
        self.totalTimeLabel = nil
        self.lrcLabel = nil
        self.costTimeLabel = nil
        self.progressSlider = nil
        self.btnPlayOrPause = nil
        self.btnPre = nil
        self.btnNext = nil
        self.btnClose = nil
        self.vcLyric = nil
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        self.updateLrcLink?.invalidate()
        self.updateLrcLink = nil
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.backImageView?.snp.removeConstraints()
        self.backImageView?.snp.makeConstraints({[weak self] (maker) in
            if self != nil {
                maker.edges.equalTo(self!.view).inset(UIEdgeInsets.zero)
            }
        })
        self.visualEffectView?.snp.removeConstraints()
        self.visualEffectView?.snp.makeConstraints({[weak self] (maker) in
            if self != nil {
                maker.edges.equalTo(self!.view).inset(UIEdgeInsets.zero)
            }
        })
    }
    /// 初始化控件
    override func innerInit() {
        super.innerInit()
        
        self.backImageView = UIImageView(image: UIImage(named: "dzq.jpg"))
        self.view.addSubview(self.backImageView!)
        
        self.visualEffectView = UIVisualEffectView()
        self.view.addSubview(self.visualEffectView!)
        
        self.topView = UIView()
        self.visualEffectView?.contentView.addSubview(self.topView!)
        
        self.middleView = UIView()
        self.visualEffectView?.contentView.addSubview(self.middleView!)
        
        self.bottomView = UIView()
        self.visualEffectView?.contentView.addSubview(self.bottomView!)
    }

}
