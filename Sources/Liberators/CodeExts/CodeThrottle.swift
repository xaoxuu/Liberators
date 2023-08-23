//
//  CodeThrottle.swift
//  
//
//  Created by xaoxuu on 2023/8/23.
//

import Foundation

/// 引用防止释放
fileprivate var storedInstances = [String: CodeThrottle.Model]()

/// 代码节流：短时间内避免重复执行，只响应第一次调用
/// 创建后会被内部强引用，时间结束后自动解除引用
public class CodeThrottle {
    
    fileprivate struct Model {
        let identifier: String
        let timeout: TimeInterval
        
        let targetCodes: () -> Void
        let onThrottling:  (() -> Void)?
        
        fileprivate var timer: Timer
        
        init(identifier: String, timeout: TimeInterval, targetCodes: @escaping () -> Void, onThrottling: (() -> Void)?) {
            self.identifier = identifier
            self.timeout = timeout
            self.targetCodes = targetCodes
            self.onThrottling = onThrottling
            timer = .init(timeInterval: timeout, repeats: false, block: { t in
                storedInstances[identifier] = nil
                t.invalidate()
            })
        }
    }
    
    fileprivate var model: Model
    
    /// 创建节流器
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - timeout: 超时时间
    ///   - targetCodes: 需要被节流的代码
    ///   - onThrottling: 当正在节流期间又尝试调用时会抛出此回调
    @discardableResult
    @objc public init(identifier: String, timeout: TimeInterval, targetCodes: @escaping () -> Void, onThrottling: (() -> Void)? = nil) {
        self.model = .init(identifier: identifier, timeout: timeout, targetCodes: targetCodes, onThrottling: onThrottling)
        if let _ = storedInstances[identifier] {
            // 正在冷却中
            model.onThrottling?()
        } else {
            // 未在冷却中，立即执行
            model.targetCodes()
            // 开始冷却
            storedInstances[identifier] = model
            RunLoop.main.add(model.timer, forMode: .common)
        }
    }
    
    /// 以当前代码行为唯一标识符创建节流器
    /// - Parameters:
    ///   - timeout: 超时时间
    ///   - targetCodes: 需要被节流的代码
    ///   - onThrottling: 当正在节流期间又尝试调用时会抛出此回调
    @discardableResult
    @objc public convenience init(file: String = #file, line: Int = #line, timeout: TimeInterval, targetCodes: @escaping () -> Void, onThrottling: (() -> Void)? = nil) {
        self.init(identifier: "\(file)#\(line)", timeout: timeout, targetCodes: targetCodes, onThrottling: onThrottling)
    }
    
}
