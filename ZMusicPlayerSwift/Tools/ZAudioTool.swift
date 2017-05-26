//
//  ZAudioTool.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 22/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import AVFoundation

class ZAudioTool: NSObject, AVAudioPlayerDelegate {
    
    /// 播放器对象
    public var currentPlayer: AVAudioPlayer?
    /// 单例模式
    public class var sharedInstance: ZAudioTool {
        struct StaticAudioTool {
            static let instance: ZAudioTool = ZAudioTool()
        }
        return StaticAudioTool.instance
    }
    /// 重置初始化方法
    override init() {
        super.init()
        self.setBackPlayConfigure()
    }
    /// 设置占用音频通道
    func setBackPlayConfigure() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            
        }
    }
    /**
     *  根据文件名, 播放一首音乐
     *
     *  @param fileName 文件名
     *
     *  @return 当前播放器
     */
    func playAudio(fileName: String) -> AVAudioPlayer? {
        // 根据名称, 获取资源路径
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return nil
        }
        return self.playAudio(url: fileURL)
    }
    /**
     *  根据文件地址, 播放一首音乐
     *
     *  @param url  文件地址
     *
     *  @return 当前播放器
     */
    func playAudio(url: URL) -> AVAudioPlayer? {
        // 业务逻辑优化, 如果发现, 播放的是当前正在播放的歌曲, 不需要重新创建播放器对象, 直接开始播放就行
        if self.currentPlayer != nil && self.currentPlayer?.url?.absoluteString == url.absoluteString {
            self.startAudio()
            return self.currentPlayer
        }
        do {
            // 根据资源路径, 创建播放器对象
            try self.currentPlayer = AVAudioPlayer(contentsOf: url)
            // 设置播放器的代理
            self.currentPlayer?.delegate = self
            // 开始播放
            self.currentPlayer?.prepareToPlay()
            self.startAudio()
        } catch {
            
        }
        return self.currentPlayer
    }
    /**
     *  开始当前正在播放的音乐
     */
    func startAudio() {
        self.currentPlayer?.play()
    }
    /**
     *  暂停当前正在播放的音乐
     */
    func pauseAudio() {
        self.currentPlayer?.pause()
    }
    /**
     *  停止当前正在播放的音乐
     */
    func stopAudio() {
        self.currentPlayer?.stop()
        self.currentPlayer?.delegate = nil
        self.currentPlayer = nil
    }
    /**
     *  设置当前播放器的播放进度
     *
     *  @param currentTime  播放时间
     */
    func seekToTimeInterval(currentTime: TimeInterval) {
        self.currentPlayer?.currentTime = currentTime
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    /**
     *  音乐播放完成、发送通知告诉外界
     *
     *  @param player   音乐播放器
     *  @param flag     是否完成
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            NotificationCenter.default.post(name: kNotificationPlayFinish, object: self.currentPlayer)
        }
    }
    /**
     *  音乐播放错误、发送通知告诉外界
     *
     *  @param player   音乐播放器
     *  @param error    错误信息
     */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        NotificationCenter.default.post(name: kNotificationPlayError, object: self.currentPlayer)
    }
}
