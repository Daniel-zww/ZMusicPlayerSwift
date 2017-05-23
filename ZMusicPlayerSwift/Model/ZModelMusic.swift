//
//  ZModelMusic.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 19/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 音乐对象
class ZModelMusic: NSObject {
    
    /// 歌曲名称
    var musicName: String?
    /// 音乐播放地址
    var musicFileName: String?
    /// 歌词文件名
    var lrcFileName: String?
    /// 歌手名称
    var singer: String?
    /// 歌手头像
    var singerIcon: String?
    /// 歌曲图片
    var musicIcon: String?
    /// 歌曲收听数
    var musicListen: CLongLong = 0
}
