//
//  ModelMusicPlayer.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 19/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 当前播放音乐对象
class ModelMusicPlayer: NSObject {
    
    /// 当前正在播放的音乐数据模型
    var modelMusic: ZModelMusic?
    /// 当前播放的时长
    var currentTime: TimeInterval = 0
    /// 当前播放总时长
    var totalTime: TimeInterval = 0
    /// 当前的播放状态
    var isPlaying: Bool = false
}
