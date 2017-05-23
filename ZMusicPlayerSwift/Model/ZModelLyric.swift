//
//  ZModelLyric.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 19/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

/// 歌词对象
class ZModelLyric: NSObject {
    
    /// 歌词内容
    var lyricText: String?
    /// 开始时间
    var beginTime: TimeInterval = 0
    /// 结束时间
    var endTime:TimeInterval = 0
}
