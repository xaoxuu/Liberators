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
        let scenes = UIWindowScene.connectedWindowScenes(.foregroundActive)
        if scenes.count > 0 {
            let ws = scenes.flatMap({ $0.windows })
            if ws.count > 0 {
                return ws
            }
        }
        return UIApplication.shared.windows
    }
    
    /// 所有可见窗口
    @objc static var visibleWindows: [UIWindow] {
        allWindows.filter { $0.isHidden == false }
    }
    
    /// App主程序窗口可能的集合
    @objc static var visibleNormalUIWindows: [UIWindow] {
        visibleWindows.filter { window in
            return "\(type(of: window))" == "UIWindow" && window.windowLevel == .normal
        }
    }
    
    /// App主程序窗口
    @objc static var appMainWindow: UIWindow? {
        visibleNormalUIWindows.first
    }
    
    /// App主程序窗口的尺寸
    @objc static var appBounds: CGRect {
        appMainWindow?.bounds ?? UIScreen.main.bounds
    }

    /// App主程序窗口的安全边距
    @objc static var appSafeAreaInsets: UIEdgeInsets { appMainWindow?.safeAreaInsets ?? .zero }

}

