//
//  ZLyricModelTool.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 22/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZLyricModelTool: NSObject {
    /**
     *  根据歌词名称,解析歌词
     *
     *  @param fileName 歌词名称
     *
     *  @return 歌词数据模型组成的数据
     */
    public static func getLyricModels(fileName: String?) -> [ZModelLyric]? {
        if fileName == nil {
            return nil
        }
        // 获取到歌词文件的路径,如果是网络数据修改成本地沙盒地址
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            return nil
        }
        do {
            // 加载歌词的所有内容
            let lyricContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            // 将歌词分割成每一行
            let arrayText = lyricContent.components(separatedBy: "\n")
            // 用于存储歌词数据模型的数组
            var arrayLyric = [ZModelLyric]()
            // 遍历每一行, 对每一行歌词进行解析
            for text in arrayText {
                // 过滤垃圾数据
                if text.contains("[ti:]") ||
                    text.contains("[ar:]") ||
                    text.contains("[al:]") {
                    continue
                }
                // 处理正常解析歌词
                // 去除[
                let timeAndText = text.replacingOccurrences(of: "[", with: "")
                // 包含时间和歌词内容
                let arrayTimeAndText = timeAndText.components(separatedBy: "]")
                let beginTime = arrayTimeAndText.first
                let lyricContent = arrayTimeAndText.last
                // 创建歌词数据模型并且赋值
                let model = ZModelLyric()
                if let beginTime = beginTime {
                    model.beginTime = beginTime.toTimeInterval()
                }
                if let lyricContent = lyricContent {
                    model.lyricText = lyricContent
                }
                arrayLyric.append(model)
            }
            // 处理得到结束时间
            let count = arrayLyric.count
            for (i, model) in arrayLyric.enumerated() {
                if i == (count - 1) {
                    break
                }
                let nextModel = arrayLyric[i+1]
                model.endTime = nextModel.beginTime
            }
            return arrayLyric
        } catch {
            
        }
        return nil
    }
    /**
     *  根据当前时间获取歌词数据模型组成的数据, 获取对应的应该播放的歌词数据模型
     *
     *  @param currentTime  当前时间
     *  @param arrayLyric   歌词数据模型数组
     *
     *  @return 索引
     */
    public static func getRow(currentTime: TimeInterval, arrayLyric: [ZModelLyric]?) -> Int {
        guard let arrayLyric = arrayLyric else {
            return 0
        }
        let count = arrayLyric.count
        for (i, model) in arrayLyric.enumerated() {
            if (currentTime >= model.beginTime && currentTime < model.endTime) {
                return i
            }
        }
        // 如果都没查找到, 并且是存在时间, 是当做最后一行处理, 防止跳回到第一行
        if currentTime > 0 {
            return (count - 1) > 0 ? (count - 1) : 0
        }
        return 0
    }
}
