//
//  CodeDebounce.swift
//  
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit

/// 引用防止释放
fileprivate var storedInstances = [String: CodeDebounce.Model]()

/// 代码防抖器：短时间内避免重复执行，只响应最后一次调用
public class CodeDebounce {
    
    fileprivate class Model {
        let identifier: String
        let delay: TimeInterval
        
        let targetCodes: () -> Void
        let onWaiting:  (() -> Void)?
        
        fileprivate var timer: Timer?
        
        init(identifier: String, delay: TimeInterval, targetCodes: @escaping () -> Void, onWaiting: (() -> Void)?) {
            self.identifier = identifier
            self.delay = delay
            self.targetCodes = targetCodes
            self.onWaiting = onWaiting
        }
        
        func resetTimer(delay: TimeInterval, onFinish: @escaping () -> Void) {
            timer?.invalidate()
            let identifier = identifier
            timer = Timer(timeInterval: delay, repeats: false, block: { t in
                storedInstances[identifier] = nil
                t.invalidate()
                onFinish()
            })
            RunLoop.main.add(timer!, forMode: .common)
        }
        
    }
    
    fileprivate var model: Model
    
    /// 创建防抖器
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - delay: 防抖持续时间（延迟时间）
    ///   - targetCodes: 要被防抖处理的代码
    ///   - onWaiting: 当处于防抖等待期间又尝试调用时会抛出此事件
    @discardableResult
    @objc public init(identifier: String, delay: TimeInterval, targetCodes: @escaping () -> Void, onWaiting: (() -> Void)? = nil) {
        self.model = .init(identifier: identifier, delay: delay, targetCodes: targetCodes, onWaiting: onWaiting)
        let onFinish = {
            storedInstances[identifier] = nil
            targetCodes()
        }
        if var obj = storedInstances[identifier] {
            // 重设延迟
            obj.resetTimer(delay: delay, onFinish: onFinish)
            obj.onWaiting?()
        } else {
            storedInstances[identifier] = model
            model.resetTimer(delay: delay, onFinish: onFinish)
        }
    }
    
    /// 以当前代码行为唯一标识符创建防抖器
    /// - Parameters:
    ///   - delay: 防抖持续时间（延迟时间）
    ///   - targetCodes: 要被防抖处理的代码
    ///   - onWaiting: 当处于防抖等待期间又尝试调用时会抛出此事件
    @discardableResult
    @objc public convenience init(file: String = #file, line: Int = #line, delay: TimeInterval, targetCodes: @escaping () -> Void, onWaiting: (() -> Void)? = nil) {
        self.init(identifier: "\(file)#\(line)", delay: delay, targetCodes: targetCodes, onWaiting: onWaiting)
    }
    
}
