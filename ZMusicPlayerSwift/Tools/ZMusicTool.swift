//
//  ZMusicTool.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 22/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import MediaPlayer

class ZMusicTool: NSObject {
    
    /// 设置播放器
    private var audioTool: ZAudioTool {
        return ZAudioTool.sharedInstance
    }
    /// 当前播放索引
    private var currentIndex: Int = 0
    
    /// 存放的播放列表
    public var arrayMusic: [ZModelMusic]?
    /// 歌曲信息数据模型
    public var modelMusicPlayer: ModelMusicPlayer {
        get {
            struct StaticMusic {
                static let instance: ModelMusicPlayer = ModelMusicPlayer()
            }
            if self.arrayMusic != nil {
                StaticMusic.instance.modelMusic = self.arrayMusic![self.currentIndex]
            }
            if self.audioTool.currentPlayer != nil {
                StaticMusic.instance.currentTime = self.audioTool.currentPlayer!.currentTime
                StaticMusic.instance.totalTime = self.audioTool.currentPlayer!.duration
                StaticMusic.instance.isPlaying = self.audioTool.currentPlayer!.isPlaying
            }
            return StaticMusic.instance
        }
    }
    /// 单例模式
    public class var sharedInstance: ZMusicTool {
        struct StaticMusicTool {
            static let instance: ZMusicTool = ZMusicTool()
        }
        return StaticMusicTool.instance
    }
    /// 播放器对象
    var currentPlayer: AVAudioPlayer?
    /// 重置初始化方法
    override init() {
        super.init()
    }
    /**
     *  在播放某一首音乐对应的数据模型时
     *
     *  @param musicModel 音乐数据模型
     */
    func playMusic(modelMusic: ZModelMusic) {
        self.currentPlayer = self.audioTool.playAudio(fileName: modelMusic.musicFileName ?? kEmpty)
        let arrayFileName = self.arrayMusic?.valueForKeyPath(field: "musicFileName")
        if let arrayFileName = arrayFileName, let fileName = modelMusic.musicFileName {
            self.currentIndex = arrayFileName.indexOfObject(value: fileName)
        }
    }
    /**
     *  继续播放当前音乐
     */
    func playCurrentMusic() {
        if let modelMusic = self.arrayMusic?[self.currentIndex] {
            self.playMusic(modelMusic: modelMusic)
        }
    }
    /**
     *  暂停当前正在播放的音乐
     */
    func pauseCurrentMusic() {
        self.audioTool.pauseAudio()
    }
    /**
     *  播放下一首
     */
    func nextMusic() {
        self.currentIndex -= 1
        self.currentIndexChange()
        self.playCurrentMusic()
    }
    /**
     *  播放上一首
     */
    func preMusic() {
        self.currentIndex += 1
        self.currentIndexChange()
        self.playCurrentMusic()
    }
    /// 验证索引是否有效
    func currentIndexChange() {
        if let arrayMusic = self.arrayMusic {
            if (self.currentIndex < 0) {
                self.currentIndex = arrayMusic.count - 1
                return
            }
            if self.currentIndex > arrayMusic.count - 1 {
                self.currentIndex = 0
                return
            }
        } else {
            self.currentIndex = 0
        }
    }
    /**
     *  设置播放的进度
     */
    func seekToTimeInterval(currentTime: TimeInterval) {
        self.audioTool.seekToTimeInterval(currentTime: currentTime)
    }
    /**
     *  更新锁屏信息
     */
    func updateLockScreenInfo() {
        if let model = self.modelMusicPlayer.modelMusic, let musicName = model.musicName, let singer = model.singer {
            var image: UIImage? = nil
            if model.musicIcon != nil {
                image = UIImage(named: model.musicIcon!)
            }
            if image == nil {
                image = UIImage(named: "QQListBack.jpg")!
            }
            let artwork = MPMediaItemArtwork(image: image!)
            let dicNowInfo: [String: Any] = [MPMediaItemPropertyAlbumTitle: musicName,
                              MPMediaItemPropertyPlaybackDuration: self.modelMusicPlayer.totalTime,
                              MPNowPlayingInfoPropertyElapsedPlaybackTime: self.modelMusicPlayer.currentTime,
                              MPMediaItemPropertyArtist: singer,
                              MPMediaItemPropertyArtwork: artwork]
            // 获取当前锁屏的播放信息中心
            MPNowPlayingInfoCenter.default().nowPlayingInfo = dicNowInfo
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
    }
}
