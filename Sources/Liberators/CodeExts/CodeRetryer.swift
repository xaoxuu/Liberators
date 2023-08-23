//
//  CodeRetryer.swift
//  
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit

/// 引用防止释放
fileprivate var storedInstances = [String: CodeRetryable.Retryer]()

/// 代码重试器，创建后会被内部强引用，直至达到重试次数或者调用invalidate()后解除。
public class CodeRetryable {
    
    /// 默认的重试次数
    @objc public static var defaultRetryTimes: Int = 3
    
    @objc(CodeRetryerModel) public class Retryer: NSObject {
        
        let identifier: String
        
        /// 最多重试次数
        @objc public let limitTimes: Int
        
        /// 当前重试次数
        @objc public private(set) var currentTimes: Int = 0 {
            didSet {
                if currentTimes > limitTimes {
                    invalidate()
                    onLimitReached?()
                }
            }
        }
        
        /// 此重试器是否有效
        @objc public private(set) var isValid: Bool = true
        
        /// 需要被重试的代码
        var targetCodes: (_ retryer: CodeRetryable.Retryer) -> Void
        
        var onLimitReached: (() -> Void)?
        
        init(identifier: String, limitTimes: Int, targetCodes: @escaping (_ retryer: CodeRetryable.Retryer) -> Void, onLimitReached: (() -> Void)?) {
            self.identifier = identifier
            self.limitTimes = limitTimes
            self.targetCodes = targetCodes
            self.onLimitReached = onLimitReached
        }
        
        /// 使此重试器失效
        @objc public func invalidate() {
            isValid = false
            storedInstances[identifier] = nil
        }
        
        /// 重试
        /// - Parameters:
        ///   - queue: 线程
        ///   - after: 延迟
        @objc public func `continue`(queue: DispatchQueue, after: TimeInterval) {
            queue.asyncAfter(deadline: .now() + after) {
                self.continue()
            }
        }
        
        @objc public func `continue`() {
            guard isValid else { return }
            currentTimes += 1
            guard isValid else { return }
            targetCodes(self)
        }
        
    }
    
    fileprivate var retryer: Retryer
    
    /// 创建重试器
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - limitTimes: 最大重试次数
    ///   - runItImmediately: 是否立即执行一次
    ///   - targetCodes: 需要被重试的代码
    ///   - onLimitReached: 当到达最大重试次数时会抛出此事件
    @discardableResult
    public init(identifier: String, limitTimes: Int = CodeRetryable.defaultRetryTimes, runItImmediately: Bool = true, targetCodes: @escaping (_ retryer: CodeRetryable.Retryer) -> Void, onLimitReached: (() -> Void)? = nil) {
        self.retryer = .init(identifier: identifier, limitTimes: limitTimes, targetCodes: targetCodes, onLimitReached: onLimitReached)
        if let obj = storedInstances[identifier] {
            obj.invalidate()
        }
        storedInstances[identifier] = retryer
        if runItImmediately {
            targetCodes(retryer)
        }
    }
    
    
    /// 以当前代码行为唯一标识符创建重试器
    /// - Parameters:
    ///   - limitTimes: 最大重试次数
    ///   - runItImmediately: 是否立即执行一次
    ///   - targetCodes: 需要被重试的代码
    ///   - onLimitReached: 当到达最大重试次数时会抛出此事件
    @discardableResult
    public convenience init(file: String = #file, line: Int = #line, limitTimes: Int = CodeRetryable.defaultRetryTimes, runItImmediately: Bool = true, targetCodes: @escaping (_ retryer: CodeRetryable.Retryer) -> Void, onLimitReached: (() -> Void)? = nil) {
        self.init(identifier: "\(file)#\(line)", limitTimes: limitTimes, runItImmediately: runItImmediately, targetCodes: targetCodes, onLimitReached: onLimitReached)
    }
    
    /// 查找重试器
    /// - Parameter identifier: 唯一标识符
    /// - Returns: 重试器
    @objc public static func find(identifier: String) -> Retryer? {
        storedInstances[identifier]
    }
    
}


extension CodeRetryable {
    fileprivate static var timeStr: String { "timestamp-\(Date().timeIntervalSince1970)" }
}
