//
//  WindowSceneExts.swift
//  Liberators
//
//  Created by xaoxuu on 2021/7/20.
//  Copyright © 2021 xaoxuu.com. All rights reserved.
//

import UIKit

public extension UIWindowScene {
    
    @objc static func connectedWindowScenes(_ state: UIScene.ActivationState) -> [UIWindowScene] {
        UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).filter({ $0.activationState == state })
    }
    
    @objc static var lastConnectedWindowScene: UIWindowScene? {
        connectedWindowScenes(.foregroundActive).last
    }
    
    
    /// 当前scene下的所有可见窗口
    @objc var visibleWindows: [UIWindow] {
        windows.filter { $0.isHidden == false }
    }
    
    
    /// 当前scene下的App主程序窗口
    @objc var appMainWindow: UIWindow? {
        visibleWindows.filter { window in
            return "\(type(of: window))" == "UIWindow" && window.windowLevel == .normal
        }.first
    }
    
    /// 当前scene下的App主程序窗口的尺寸
    @objc var appBounds: CGRect {
        appMainWindow?.bounds ?? UIScreen.main.bounds
    }

    /// 当前scene下的App主程序窗口的安全边距
    @objc var appSafeAreaInsets: UIEdgeInsets { appMainWindow?.safeAreaInsets ?? .zero }

}


