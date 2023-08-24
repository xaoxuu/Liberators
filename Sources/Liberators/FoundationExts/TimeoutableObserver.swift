//
//  CodeTimeout.swift
//  
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit

/// 引用防止释放
fileprivate var storedInstances = [String: TimeoutableObserver.Observer]()

public class TimeoutableObserver {
    
    fileprivate struct Observer {
        let identifier: String
        let timeout: TimeInterval
        
        let onResponse: (Any?) -> Void
        let onTimeout:  (() -> Void)?
        
        fileprivate var timer: Timer
        
        init(identifier: String, timeout: TimeInterval, onResponse: @escaping (Any?) -> Void, onTimeout: (() -> Void)?) {
            self.identifier = identifier
            self.timeout = timeout
            self.onResponse = onResponse
            self.onTimeout = onTimeout
            timer = .init(timeInterval: timeout, repeats: false, block: { t in
                onTimeout?()
                storedInstances[identifier] = nil
            })
            RunLoop.main.add(timer, forMode: .common)
        }
        
    }
    
    fileprivate var observer: Observer?
    
    /// 设置一次性临时观察者
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - timeout: 超时时间
    ///   - onResponse: 收到响应事件
    ///   - onTimeout: 超时未收到响应事件
    @discardableResult
    public init(_ identifier: String, timeout: TimeInterval, onResponse: @escaping (_ response: Any?) -> Void, onTimeout: (() -> Void)? = nil) {
        observer = .init(identifier: identifier, timeout: timeout, onResponse: onResponse, onTimeout: onTimeout)
        storedInstances[identifier] = observer
    }
    
    /// 发送响应
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - object: 携带对象
    @objc public static func onResponse(_ identifier: String, object: Any?) {
        guard let observer = storedInstances[identifier] else {
            return
        }
        observer.onResponse(object)
        observer.timer.invalidate()
        storedInstances[identifier] = nil
    }
    
}
