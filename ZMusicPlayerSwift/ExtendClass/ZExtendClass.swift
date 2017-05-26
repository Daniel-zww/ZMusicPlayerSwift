//
//  ZExtendClass.swift
//  ZMusicPlayerSwiftDemo
//
//  Created by Daniel on 19/05/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC.runtime

/// 定义空字符串
public let kEmpty: String = ""
/// 播放完成通知
public let kNotificationPlayFinish: NSNotification.Name = NSNotification.Name(rawValue: "kNotificationPlayFinish")
/// 播放错误通知
public let kNotificationPlayError: NSNotification.Name = NSNotification.Name(rawValue: "kNotificationPlayError")


/// 添加文字在图片的方位
public enum ZImageTextPosition : Int {
    /// 上右
    case upRight
    /// 上左
    case upLeft
    /// 下右
    case downRight
    /// 下左
    case downLeft
}
/// 扩展文本内容
extension UILabel {
    /// 用于计算字符串使用
    public static let shareCalculation = UILabel()
    /// 根据参数获取文本宽度
    func getLabelWidth(minW: CGFloat) -> CGFloat {
        var width: CGFloat = 0
        if let text = self.text {
            width = text.getTextWidth(height: self.frame.size.height, 10, [NSFontAttributeName: self.font])
        }
        return width
    }
    /// 根据参数获取文本高度
    func getLabelHeight(minH: CGFloat) -> CGFloat {
        var height: CGFloat = 0
        if let text = self.text {
            height = text.getTextHeight(width: self.frame.size.width, 15, [NSFontAttributeName: self.font])
        }
        return height
    }
}
/// 扩展字符串
extension String {
    /// 转换成Int
    var intValue: Int64 {
        if let value = Int64(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
            return value
        }
        return 0
    }
    /// 转换成Float
    var floatValue: Float {
        if let value = Float(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
            return value
        }
        return 0
    }
    /// 根据字符串获取宽度
     func getTextWidth(height: CGFloat, _ minW: CGFloat, _ attributes: [String: Any]) -> CGFloat {
        let text = self
        var width: CGFloat = 0
        let fontSize = CGSize(width: Double.greatestFiniteMagnitude, height: Double(height))
        let fontFrame = NSString(string: text).boundingRect(with: fontSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        width = fontFrame.size.width < minW ? minW : (fontFrame.size.width + 1)
        return width
    }
    /// 根据字符串获取高度
     func getTextHeight(width: CGFloat, _ minH: CGFloat, _ attributes: [String: Any]) -> CGFloat {
        let text = self
        var height: CGFloat = 0
        let fontSize = CGSize(width: Double(width), height: Double.greatestFiniteMagnitude)
        let fontFrame = NSString(string: text).boundingRect(with: fontSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        height = fontFrame.size.height < minH ? minH : (fontFrame.size.height + 1)
        return height
    }
    /// 根据  "分钟:秒数" 的格式 , 例如 "06:02" 转换成为 秒数
    func toTimeInterval() -> TimeInterval {
        // 分解小时,分钟,秒数
        let array = self.components(separatedBy: ":")
        var time: TimeInterval = 0
        if array.count == 2 {
            // 分钟
            let min = array.first
            // 秒数
            let sec = array.last
            if let min = min, let sec = sec {
                time = TimeInterval(min.floatValue * 60 + sec.floatValue)
            }
        } else if array.count == 3 {
            // 小时
            let hour = array.first
            // 分钟
            let min = array[1] as String
            // 秒数
            let sec = array.last
            if let hour = hour, let sec = sec {
                time = TimeInterval(hour.floatValue * 60 * 60 + min.floatValue * 60 + sec.floatValue)
            }
        }
        return time
    }
}
/// 扩展图片
extension UIImage {
    /// 创建文字水印的图片
    func createNewImage(text: String, _ position: ZImageTextPosition) -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes = [NSForegroundColorAttributeName: UIColor.white,
                          NSParagraphStyleAttributeName: style,
                          NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
        var textFrame = CGRect.zero
        let space: CGFloat = 2
        let textH: CGFloat = 24
        let textW: CGFloat = text.getTextWidth(height: textH, 10, attributes);
        let imgW = self.size.width
        let imgH = self.size.height
        switch position {
        case .upLeft:
            textFrame = CGRect(x: space, y: space, width: textW, height: textH)
        case .upRight:
            textFrame = CGRect(x: imgW - textW - space, y: space, width: textW, height: textH)
        case .downLeft:
            textFrame = CGRect(x: space, y: imgH - textH - space, width: textW, height: textH)
        case .downRight:
            textFrame = CGRect(x: imgW - textW - space, y: imgH - textH - space, width: textW, height: textH)
        }
        (text as NSString).draw(in: textFrame, withAttributes: attributes)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}
/// 扩展时间
extension TimeInterval {
    /// 根据秒数, 转换成为 "分钟:秒数" 的格式 , 例如 "06:02"
    func toFormatTime() -> String {
        // 获取小时
        let hour = Int64(self) / 3600
        // 获取分钟数
        let min = (Int64(self) % 3600) / 60
        // 获取秒数
        let sec = Int64(self) % 60
        if hour >= 10 {
            if min >= 10 {
                if sec > 10 {
                    return String("\(hour):\(min):\(sec)")
                }
                return String("\(hour):\(min):0\(sec)")
            } else {
                if sec > 10 {
                    return String("\(hour):0\(min):\(sec)")
                }
                return String("\(hour):0\(min):0\(sec)")
            }
        } else if hour > 0 && hour < 10 {
            if min >= 10 {
                if sec > 10 {
                    return String("0\(hour):\(min):\(sec)")
                }
                return String("0\(hour):\(min):0\(sec)")
            } else {
                if sec > 10 {
                    return String("0\(hour):0\(min):\(sec)")
                }
                return String("0\(hour):0\(min):0\(sec)")
            }
        }
        if min >= 10 {
            if sec > 10 {
                return String("\(min):\(sec)")
            }
            return String("\(min):0\(sec)")
        } else {
            if sec > 10 {
                return String("0\(min):\(sec)")
            }
            return String("0\(min):0\(sec)")
        }
    }
}
/// 扩展动画
extension CALayer {
    /// 暂停动画
    func pauseAnimate() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }
    /// 恢复动画
    func resumeAnimate() {
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
fileprivate let kNameTagKey: UnsafeRawPointer = UnsafeRawPointer(bitPattern: 1)!
/// 扩展View
extension UIView {
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set (newValue) {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set (newValue) {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set (newValue) {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newValue) {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set (newValue) {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (newValue) {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var size: CGSize {
        get {
            return self.frame.size
        }
        set (newValue) {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set (newValue) {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    /// 设置字符串Tag
    func setNameTag(tag: String) {
        objc_setAssociatedObject(self, kNameTagKey, tag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    /// 获取字符串Tag
    func getNameTag() -> String? {
        if let tag = objc_getAssociatedObject(self, kNameTagKey) {
            return tag as? String
        }
        return nil
    }
    /// 根据Tag获取View
    func viewNameTag(tag: String) -> UIView? {
        guard let selfTag = self.getNameTag(), selfTag == tag else {
            for view in self.subviews {
                if tag == view.getNameTag() {
                    return view
                }
            }
            return nil
        }
        return self
    }
}
/// 扩展Array
extension Array {
    func valueForKeyPath(field: String) -> [Any] {
        var array = [Any]()
        for (_, item) in self.enumerated() {
            let model = item as AnyObject
            guard let fieldValue = model.value(forKeyPath: field) else {
                continue
            }
            array.append(fieldValue)
        }
        return array
    }
    func indexOfObject(value: Any) -> Int {
        for (i, item) in self.enumerated() {
            let val = item as AnyObject
            if val.isEqual(value) {
                return i
            }
        }
        return 0
    }
}
/// 扩展NSObject
extension NSObject {
    
}
/// 扩展颜色
extension UIColor {
    convenience init(_ r: UInt8, _ g: UInt8 , _ b: UInt8) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}





