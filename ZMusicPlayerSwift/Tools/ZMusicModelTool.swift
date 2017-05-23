//
//  ZMusicModelTool.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 22/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZMusicModelTool: NSObject {
    /**
     *  加载本地设置的音乐配置文件
     *
     *  @param  resultBlock 返回结果集合
     */
    public static func loadLocalMusicModelArray(resultBlock: ([ZModelMusic]?) -> Void) {
        guard let path = Bundle.main.path(forResource: "Musics", ofType: "plist") else {
            resultBlock(nil)
            return
        }
        guard let arrayDic = NSArray(contentsOfFile: path) else {
            resultBlock(nil)
            return
        }
        let arrayModel = ZModelMusic.dcObjectArrayWithKeyValuesArray(arrayDic) as! [ZModelMusic]
        resultBlock(arrayModel)
    }
}
