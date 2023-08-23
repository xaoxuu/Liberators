//
//  ColorExts.swift
//  Liberators
//
//  Created by xaoxuu on 2019/3/26.
//  Copyright © 2019 xaoxuu.com. All rights reserved.
//

import UIKit

// MARK: - 颜色工具
public extension UIColor {
    
    /// 变深
    /// - Parameter ratio: 比例(0~1)
    /// - Returns: 变深后的颜色
    func darken(_ ratio: CGFloat = 0.5) -> UIColor {
        var tmp = hsba
        tmp.brightness = tmp.brightness * (1 - ratio)
        return .init(hsba: tmp)
    }
    
    /// 变浅
    /// - Parameter ratio: 比例(0~1)
    /// - Returns: 变浅后的颜色
    func lighten(_ ratio: CGFloat = 0.5) -> UIColor {
        var tmp = hsba
        tmp.brightness = tmp.brightness * (1 - ratio) + ratio
        return .init(hsba: tmp)
    }
    
    /// 根据hex字符串创建颜色
    /// - Parameter hex: hex字符串(例如#2196F3)
    /// 兼容3、4、6、8位长度的格式：#fff、#ffff、#ffffff、#ffffffff
    convenience init(_ hex: String) {
        func removePrefix(_ hex: String) -> String {
            let set = NSCharacterSet.whitespacesAndNewlines
            var str = hex.trimmingCharacters(in: set).lowercased()
            if str.hasPrefix("#") {
                str = String(str.suffix(str.count-1))
            } else if str.hasPrefix("0x") {
                str = String(str.suffix(str.count-2))
            }
            return str
        }
        let hex = removePrefix(hex)
        let length = hex.count
        guard length == 3 || length == 4 || length == 6 || length == 8 else {
            print("无效的hex: \(hex)")
            self.init(white: 0, alpha: 1)
            return
        }
        // 分别截取rgba
        func getRGBA(_ hex: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            func substring(of hex: String, loc: Int) -> String {
                if length == 3 || length == 4 {
                    return hex[location: loc, length: 1]
                } else if length == 6 || length == 8 {
                    return hex[location: loc * 2, length: 2]
                } else {
                    return ""
                }
            }
            // 16进制字符串转成0~255十进制数字并除以255得到0~1
            func floatValue(_ hex: String) -> CGFloat {
                CGFloat(Int.init(hex, radix: 16) ?? 0) / 255
            }
            let r = floatValue(substring(of: hex, loc: 0))
            let g = floatValue(substring(of: hex, loc: 1))
            let b = floatValue(substring(of: hex, loc: 2))
            var a = CGFloat(1)
            if length == 4 || length == 8 {
                a = floatValue(substring(of: hex, loc: 3))
            }
            return (r, g, b, a)
        }
        self.init(rgba: getRGBA(hex))
    }
    
    /// 生成当前颜色的hex字符串
    var hexString: String {
        func maxHexValue() -> CGFloat {
            var max = Float(0)
            Scanner(string: "0xff").scanHexFloat(&max)
            return CGFloat(max)
        }
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(1)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rr = String(format: "%02X", UInt32(r*maxHexValue()))
        let gg = String(format: "%02X", UInt32(g*maxHexValue()))
        let bb = String(format: "%02X", UInt32(b*maxHexValue()))
        let aa = String(format: "%02X", UInt32(a*maxHexValue()))
        
        return "#" + rr + gg + bb + aa
    }
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    // Returns a color in the same color space as the receiver with the specified hue component.
    func withHueComponent(_ hue: CGFloat) -> UIColor {
        var tmp = hsba
        tmp.hue = hue
        return .init(hsba: tmp)
    }
    
    // Returns a color in the same color space as the receiver with the specified saturation component.
    func withSaturationComponent(_ saturation: CGFloat) -> UIColor {
        var tmp = hsba
        tmp.saturation = saturation
        return .init(hsba: tmp)
    }
    
    // Returns a color in the same color space as the receiver with the specified brightness component.
    func withBrightnessComponent(_ brightness: CGFloat) -> UIColor {
        var tmp = hsba
        tmp.brightness = brightness
        return .init(hsba: tmp)
    }
    
    
    // Returns a color in the same color space as the receiver with the specified red component.
    func withRedComponent(_ red: CGFloat) -> UIColor {
        var tmp = rgba
        tmp.red = red
        return .init(rgba: tmp)
    }
    
    // Returns a color in the same color space as the receiver with the specified green component.
    func withGreenComponent(_ green: CGFloat) -> UIColor {
        var tmp = rgba
        tmp.green = green
        return .init(rgba: tmp)
    }
    
    // Returns a color in the same color space as the receiver with the specified blue component.
    func withBlueComponent(_ blue: CGFloat) -> UIColor {
        var tmp = rgba
        tmp.blue = blue
        return .init(rgba: tmp)
    }
    
    convenience init(hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)) {
        self.init(hue: hsba.hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
    
    convenience init(rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)) {
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
}

