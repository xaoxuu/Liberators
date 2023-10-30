//
//  UIExts.swift
//
//
//  Created by xaoxuu on 2023/10/30.
//

import UIKit

public extension UIImage {
    
    /// 生成纯色图片
    /// - Parameter color: 颜色
    /// - Returns: 图片
    static func image(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage? {
        guard size != .zero else { return nil }
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
