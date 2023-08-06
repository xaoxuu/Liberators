//
//  WindowExts.swift
//  Liberators
//
//  Created by xaoxuu on 2021/7/20.
//  Copyright © 2021 xaoxuu.com. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    /// 所有的窗口
    @objc static var allWindows: [UIWindow] {
        UIWindowScene.connectedWindowScenes(.foregroundActive).flatMap({ $0.windows })
    }
    
    /// App主程序窗口
    @objc static var appMainWindows: [UIWindow] {
        UIWindowScene.connectedWindowScenes(.foregroundActive).compactMap({ $0.appMainWindow })
    }
    
    /// 最后一个启动的App窗口的主程序窗口
    @objc static var lastAppMainWindow: UIWindow? {
        UIWindowScene.lastConnectedWindowScene?.appMainWindow
    }
    
}

