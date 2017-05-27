//
//  ZMusicViewController.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 23/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 播放VC
class ZMusicViewController: ZBaseViewController, UIScrollViewDelegate {
    
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    /// 单例模式
    public static var sharedInstance: ZMusicViewController {
        struct StaticMusicVC {
            static let instance: ZMusicViewController = ZMusicViewController()
        }
        return StaticMusicVC.instance
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: kNotificationPlayFinish, object: nil)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setMusicChangeOne()
        self.innerInitTimer()
        self.innerInitLink()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        
        self.updateLrcLink?.invalidate()
        self.updateLrcLink = nil
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setViewDynamicConstraints()
    }
    /// 初始化控件
    override func innerInit() {
        super.innerInit()
        
        self.backImageView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        self.view.addSubview(self.backImageView!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.view.addSubview(self.visualEffectView!)
        
        self.view.sendSubview(toBack: self.backImageView!)
        
        self.innerTopView()
        self.innerMiddleView()
        self.innerBottomView()
        self.setViewFrame()
        
        // 监听歌曲播放完成的通知
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayFinish(sender:)), name: kNotificationPlayFinish, object: nil)
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
                make.edges.equalTo(self!.view!).inset(UIEdgeInsets.zero)
            }
        })
        self.topView?.snp.removeConstraints()
        self.topView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(85)
                make.left.top.right.equalTo(self!.visualEffectView!).offset(0)
            }
        })
        self.bottomView?.snp.removeConstraints()
        self.bottomView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(120)
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
        // TopView
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
                make.top.equalTo(self!.songNameLabel!.snp.bottom).offset(10)
                make.left.equalTo(self!.btnClose!.snp.left).offset(10)
                make.right.equalTo(self!.btnShare!.snp.right).offset(-10)
            }
        })
        // MiddleView
        self.lrcLabel?.snp.removeConstraints()
        self.lrcLabel?.snp.makeConstraints ({[weak self] (make) in
            if self != nil {
                make.height.equalTo(22)
                make.left.right.equalTo(self!.middleView!).offset(0)
                make.centerX.equalTo(self!.middleView!.snp.centerX)
                make.top.equalTo(self!.iconImageView!.snp.bottom).offset(15)
            }
        })
        self.lrcBackView?.snp.removeConstraints()
        self.lrcBackView?.snp.makeConstraints {[weak self] (make) in
            if self != nil {
                make.edges.equalTo(self!.middleView!).inset(UIEdgeInsets.zero)
            }
        }
        
        // BottomView
        self.costTimeLabel?.snp.removeConstraints()
        self.costTimeLabel?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(15)
                make.width.equalTo(50)
                make.left.equalTo(self!.bottomView!.snp.left).offset(5)
                make.top.equalTo(self!.bottomView!.snp.top).offset(10)
            }
        })
        self.totalTimeLabel?.snp.removeConstraints()
        self.totalTimeLabel?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(15)
                make.width.equalTo(50)
                make.right.equalTo(self!.bottomView!.snp.right).offset(-5)
                make.top.equalTo(self!.bottomView!.snp.top).offset(10)
            }
        })
        self.progressSlider?.snp.removeConstraints()
        self.progressSlider?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.height.equalTo(31)
                make.left.equalTo(self!.costTimeLabel!.snp.right).offset(5)
                make.right.equalTo(self!.totalTimeLabel!.snp.left).offset(-5)
                make.top.equalTo(self!.bottomView!.snp.top).offset(0)
            }
        })
        self.btnPlayOrPause?.snp.removeConstraints()
        self.btnPlayOrPause?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.height.equalTo(64)
                make.centerX.equalTo(self!.bottomView!.snp.centerX)
                make.bottom.equalTo(self!.bottomView!.snp.bottom).offset(-20)
                
            }
        })
        self.btnPre?.snp.removeConstraints()
        self.btnPre?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.height.equalTo(64)
                make.right.equalTo(self!.btnPlayOrPause!.snp.left).offset(-50)
                make.bottom.equalTo(self!.bottomView!.snp.bottom).offset(-20)
            }
        })
        self.btnNext?.snp.removeConstraints()
        self.btnNext?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.height.equalTo(64)
                make.left.equalTo(self!.btnPlayOrPause!.snp.right).offset(50)
                make.bottom.equalTo(self!.bottomView!.snp.bottom).offset(-20)
            }
        })
    }
    /// 设置动态约束
    func setViewDynamicConstraints() {
        self.iconImageView?.snp.removeConstraints()
        self.iconImageView?.snp.makeConstraints({[weak self] (make) in
            if self != nil {
                make.width.height.equalTo(self!.middleView!.height / 2)
                make.center.equalTo(self!.middleView!.snp.center)
            }
        })
        self.vcLyric?.tableView.frame = self.lrcBackView?.bounds ?? CGRect.zero
        self.vcLyric?.tableView.x = self.lrcBackView?.width ?? 0
        
        self.lrcBackView?.contentSize = CGSize(width: (self.lrcBackView?.width ?? 0) * 2, height: 0)
        
        // 设置歌手头像为圆形
        self.iconImageView?.layer.cornerRadius = (self.iconImageView?.width ?? 0) / 2
        self.iconImageView?.layer.masksToBounds = true
        self.iconImageView?.layer.borderWidth = 5.0
        self.iconImageView?.layer.borderColor = UIColor(36, 36, 35).cgColor
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scale = 1 - scrollView.contentOffset.x / scrollView.width
        self.lrcLabel?.alpha = scale
        self.iconImageView?.alpha = scale
    }
}
/// 初始化控件
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
        self.songNameLabel?.text = kEmpty
        self.songNameLabel?.font = UIFont.systemFont(ofSize: 17)
        self.topView?.addSubview(self.songNameLabel!)
        
        self.singerNameLabel = UILabel()
        self.singerNameLabel?.textAlignment = .center
        self.singerNameLabel?.textColor = .white
        self.singerNameLabel?.text = kEmpty
        self.singerNameLabel?.font = UIFont.systemFont(ofSize: 13)
        self.topView?.addSubview(self.singerNameLabel!)
    }
    func innerMiddleView() {
        self.middleView = UIView()
        self.middleView?.clipsToBounds = false
        self.visualEffectView?.contentView.addSubview(self.middleView!)
        
        self.iconImageView = UIImageView(image: UIImage(named: "dzq.jpg"))
        self.middleView?.addSubview(self.iconImageView!)
        
        self.lrcLabel = ZLyricLabel()
        self.lrcLabel?.textColor = .white
        self.lrcLabel?.text = kEmpty
        self.lrcLabel?.numberOfLines = 1
        self.lrcLabel?.lineBreakMode = .byTruncatingTail
        self.lrcLabel?.textAlignment = .center
        self.middleView?.addSubview(self.lrcLabel!)
        
        self.lrcBackView = UIScrollView()
        self.lrcBackView?.delegate = self
        self.lrcBackView?.bounces = false
        self.middleView?.addSubview(self.lrcBackView!)
        
        self.vcLyric = ZLyricViewController()
        self.addChildViewController(self.vcLyric!)
        
        self.lrcBackView?.addSubview(self.vcLyric!.view)
        self.lrcBackView?.isPagingEnabled = true
        self.lrcBackView?.showsHorizontalScrollIndicator = false
        self.lrcBackView?.showsVerticalScrollIndicator = false
    }
    func innerBottomView() {
        self.bottomView = UIView()
        self.visualEffectView?.contentView.addSubview(self.bottomView!)
        
        self.costTimeLabel = UILabel()
        self.costTimeLabel?.textColor = .white
        self.costTimeLabel?.text = "00:00"
        self.costTimeLabel?.textAlignment = .center
        self.costTimeLabel?.font = UIFont.systemFont(ofSize: 13)
        self.costTimeLabel?.numberOfLines = 1
        self.costTimeLabel?.lineBreakMode = .byTruncatingTail
        self.bottomView?.addSubview(self.costTimeLabel!)
        
        self.totalTimeLabel = UILabel()
        self.totalTimeLabel?.textColor = .white
        self.totalTimeLabel?.text = "00:00"
        self.totalTimeLabel?.textAlignment = .center
        self.totalTimeLabel?.font = UIFont.systemFont(ofSize: 13)
        self.totalTimeLabel?.numberOfLines = 1
        self.totalTimeLabel?.lineBreakMode = .byTruncatingTail
        self.bottomView?.addSubview(self.totalTimeLabel!)
        
        self.progressSlider = UISlider()
        self.progressSlider?.minimumTrackTintColor = UIColor(0, 169, 38)
        self.progressSlider?.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        self.progressSlider?.addTarget(self, action: #selector(sliderValueChange(sender:)), for: UIControlEvents.valueChanged)
        self.progressSlider?.addTarget(self, action: #selector(sliderTouchDown(sender:)), for: UIControlEvents.touchDown)
        self.progressSlider?.addTarget(self, action: #selector(sliderTouchUpInside(sender:)), for: UIControlEvents.touchUpInside)
        self.bottomView?.addSubview(self.progressSlider!)
        
        self.btnPre = UIButton()
        self.btnPre?.setImage(UIImage(named: "player_btn_pre_normal"), for: UIControlState.normal)
        self.btnPre?.setImage(UIImage(named: "player_btn_pre_highlight"), for: UIControlState.highlighted)
        self.btnPre?.contentMode = .scaleToFill
        self.btnPre?.addTarget(self, action: #selector(btnPreClick), for: UIControlEvents.touchUpInside)
        self.bottomView?.addSubview(self.btnPre!)
        
        self.btnNext = UIButton()
        self.btnNext?.setImage(UIImage(named: "player_btn_next_normal"), for: UIControlState.normal)
        self.btnNext?.setImage(UIImage(named: "player_btn_next_highlight"), for: UIControlState.highlighted)
        self.btnNext?.contentMode = .scaleToFill
        self.btnNext?.addTarget(self, action: #selector(btnNextClick), for: UIControlEvents.touchUpInside)
        self.bottomView?.addSubview(self.btnNext!)
        
        self.btnPlayOrPause = UIButton()
        self.btnPlayOrPause?.setImage(UIImage(named: "player_btn_play_normal"), for: UIControlState.normal)
        self.btnPlayOrPause?.setImage(UIImage(named: "player_btn_pause_normal"), for: UIControlState.selected)
        self.btnPlayOrPause?.tag = 1
        self.btnPlayOrPause?.contentMode = .scaleToFill
        self.btnPlayOrPause?.addTarget(self, action: #selector(btnPlayOrPauseClick(sender:)), for: UIControlEvents.touchUpInside)
        self.bottomView?.addSubview(self.btnPlayOrPause!)
    }
    /// 负责更新进度等信息的timer
    func innerInitTimer() {
        if self.updateTimer == nil {
            self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setMusicChangeMany), userInfo: nil, repeats: true)
            RunLoop.current.add(self.updateTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    /// 负责更新歌词的时钟
    func innerInitLink() {
        if self.updateLrcLink == nil {
            self.updateLrcLink = CADisplayLink(target: self, selector: #selector(setMusicPlayLyricChange))
            self.updateLrcLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
    }
}
/// 事件
extension ZMusicViewController {
    @objc func btnCloseClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func btnShareClick() {
        debugPrint("点击了分享")
    }
    /// 上一首
    @objc func btnPreClick() {
        ZMusicTool.sharedInstance.preMusic()
        self.setMusicChangeOne()
    }
    /// 下一首
    @objc func btnNextClick() {
        ZMusicTool.sharedInstance.nextMusic()
        self.setMusicChangeOne()
    }
    /// 开始播放||暂停播放
    @objc func btnPlayOrPauseClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            ZMusicTool.sharedInstance.playCurrentMusic()
            self.resumeRotation()
        } else {
            ZMusicTool.sharedInstance.pauseCurrentMusic()
            self.pauseRotation()
        }
    }
    /// 改变拖动值
    @objc func sliderValueChange(sender: UISlider) {
        // 获取当前播放的音乐信息数据模型
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        // 计算当前播放的时间
        let currentTime = model.totalTime * TimeInterval(self.progressSlider!.value)
        // 修改已经播放时长的label
        self.costTimeLabel?.text = currentTime.toFormatTime()
    }
    /// 开始拖动的事件
    @objc func sliderTouchDown(sender: UISlider) {
        // 移除更新进度的timer
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }
    /// 结束拖动的事件
    @objc func sliderTouchUpInside(sender: UISlider) {
        // 添加更新进度的timer
        self.innerInitTimer()
        // 获取当前播放的音乐信息数据模型
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        // 计算当前播放的时间
        let currentTime = model.totalTime * TimeInterval(self.progressSlider!.value)
        // 根据当前时间, 确定歌曲播放的进度
        ZMusicTool.sharedInstance.seekToTimeInterval(currentTime: currentTime)
    }
    /// 当点击进度条任意一位置时调用的方法(tap手势)
    @objc func sliderTapGesture(sender: UITapGestureRecognizer?) {
        //为了解决手势冲突,造成的timer被移除情况
        self.innerInitTimer()
        // 获取当前播放的音乐信息数据模型
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        // 获取手指触摸的点
        let point = sender?.location(in: self.progressSlider!)
        // 计算触摸点在整个视图上的比例
        let scale = point!.x / self.progressSlider!.width
        // 更改进度条的值
        self.progressSlider?.value = Float(scale)
        // 计算当前播放的时间
        let currentTime = model.totalTime * TimeInterval(scale)
        // 根据当前时间, 确定歌曲播放的进度
        ZMusicTool.sharedInstance.seekToTimeInterval(currentTime: currentTime)
    }
    /// 播放完成通知事件
    @objc func setPlayFinish(sender: Notification?) {
        ZMusicTool.sharedInstance.nextMusic()
        self.setMusicChangeOne()
    }
    /// 重写远程接收事件
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else { return }
        switch event.subtype {
        case UIEventSubtype.remoteControlPlay:
            ZMusicTool.sharedInstance.playCurrentMusic()
        case UIEventSubtype.remoteControlPause:
            ZMusicTool.sharedInstance.pauseCurrentMusic()
        case UIEventSubtype.remoteControlNextTrack:
            ZMusicTool.sharedInstance.nextMusic()
        case UIEventSubtype.remoteControlPreviousTrack:
            ZMusicTool.sharedInstance.preMusic()
        default: break
        }
        self.setMusicChangeOne()
    }
}
/// 动画
extension ZMusicViewController {
    /// 开始旋转动画
    func beginRotation() {
        self.iconImageView?.layer.removeAnimation(forKey: "rotation")
        let animation = CABasicAnimation()
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 30
        animation.keyPath = "transform.rotation.z"
        animation.repeatCount = Float(NSIntegerMax)
        animation.isRemovedOnCompletion = false
        self.iconImageView?.layer.add(animation, forKey: "rotation")
    }
    /// 暂停旋转动画
    func pauseRotation() {
        self.iconImageView?.layer.pauseAnimate()
    }
    /// 恢复旋转动画
    func resumeRotation() {
        self.iconImageView?.layer.resumeAnimate()
    }
    /// 歌曲切换时、更新一次的情况
    func setMusicChangeOne() {
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        if let modelMusic = model.modelMusic {
            self.backImageView?.image = UIImage(named: modelMusic.musicIcon ?? "QQListBack.jpg")
            self.iconImageView?.image = UIImage(named: modelMusic.musicIcon ?? "QQListBack.jpg")
            
            self.songNameLabel?.text = modelMusic.musicName
            self.singerNameLabel?.text = modelMusic.singer
            self.totalTimeLabel?.text = model.totalTime.toFormatTime()
            
            self.beginRotation()
            if model.isPlaying {
                self.resumeRotation()
            } else {
                self.pauseRotation()
            }
            // 加载歌曲对应的歌词资源
            self.vcLyric?.arrayLyric = ZLyricModelTool.getLyricModels(fileName: modelMusic.lrcFileName)
        }
    }
    /// 歌曲切换时、更新多次的情况
    func setMusicChangeMany() {
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        
        self.costTimeLabel?.text = model.currentTime.toFormatTime()
        self.progressSlider?.value = Float(model.currentTime / model.totalTime)
        self.btnPlayOrPause?.isSelected = model.isPlaying
    }
    /// 歌曲播放过程中、切换歌词
    func setMusicPlayLyricChange() {
        let model = ZMusicTool.sharedInstance.modelMusicPlayer
        let row = ZLyricModelTool.getRow(currentTime: model.currentTime, arrayLyric: self.vcLyric?.arrayLyric)
        self.vcLyric?.scrollRow = row
        let modelLyric = self.vcLyric?.arrayLyric?[row]
        if let modelLyric = modelLyric {
            self.lrcLabel?.text = modelLyric.lyricText
            self.lrcLabel?.progress = CGFloat((model.currentTime - modelLyric.beginTime) / (modelLyric.endTime - modelLyric.beginTime))
        }
        if self.lrcLabel != nil {
            self.vcLyric?.progress = self.lrcLabel!.progress
        }
        ZMusicTool.sharedInstance.updateLockScreenInfo()
    }
}
