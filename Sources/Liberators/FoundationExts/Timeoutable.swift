//
//  Timeoutable.swift
//  
//
//  Created by xaoxuu on 2023/8/24.
//

import UIKit

/// 引用防止释放
fileprivate var storedInstances = [String: TimeoutableObject]()

@objc public protocol TimeoutableSubscriberType {
    
    @discardableResult @objc func onResponse(_ handler: @escaping (_ response: Any?) -> Void) -> TimeoutableSubscriberType
    @discardableResult @objc func onAccept(_ handler: @escaping (_ attachedData: Any?) -> Void) -> TimeoutableSubscriberType
    @discardableResult @objc func onRefuse(_ handler: @escaping (_ reason: Any?) -> Void) -> TimeoutableSubscriberType
    @discardableResult @objc func onTimeout(_ handler: @escaping () -> Void) -> TimeoutableSubscriberType
    
}

@objc protocol TimeoutablePublisher {
    @objc func sendResponse(_ response: Any?)
    @objc func sendAccept(_ attachedData: Any?)
    @objc func sendRefuse(_ reason: Any?)
    @objc func sendTimeout()
}

fileprivate class TimeoutableObject {
    let identifier: String
    let timeout: TimeInterval
    
    var onResponse:  ((Any?) -> Void)?
    var onAccept: ((Any?) -> Void)?
    var onRefuse: ((Any?) -> Void)?
    var onTimeout:  (() -> Void)?
    
    fileprivate var timer: Timer?
    
    init(identifier: String, timeout: TimeInterval) {
        self.identifier = identifier
        self.timeout = timeout
    }
    
    func setTimeout(_ timeout: TimeInterval) {
        timer?.invalidate()
        timer = .init(timeInterval: timeout, repeats: false, block: { [weak self] t in
            self?.onTimeout?()
            self?.invalidate()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func invalidate() {
        timer?.invalidate()
        storedInstances[identifier] = nil
    }
    
}

@objc open class Timeoutable: NSObject {
    
    fileprivate var obj: TimeoutableObject? {
        get { storedInstances[identifier] }
        set { storedInstances[identifier] = newValue }
    }
    
    @objc open var prefix: String { "" }
    
    var identifier: String
    
    @objc public init(_ identifier: String) {
        self.identifier = identifier
        super.init()
        self.identifier = self.prefix + identifier
    }
    
    @objc public func subscribe(timeout: TimeInterval) -> TimeoutableSubscriberType {
        obj = .init(identifier: identifier, timeout: timeout)
        obj?.setTimeout(timeout)
        return TimeoutableSubscriber(identifier)
    }
    
}

public extension Timeoutable {
    
    @discardableResult
    @objc func subscribe(timeout: TimeInterval, onResponse: @escaping (_ response: Any?) -> Void, onTimeout: @escaping () -> Void) -> TimeoutableSubscriberType {
        subscribe(timeout: timeout).onResponse(onResponse).onTimeout(onTimeout)
    }
    
    @discardableResult
    @objc func subscribe(timeout: TimeInterval, onAccept: @escaping (_ attachedData: Any?) -> Void, onRefuse: @escaping (_ reason: Any?) -> Void, onTimeout: @escaping () -> Void) -> TimeoutableSubscriberType {
        subscribe(timeout: timeout).onAccept(onAccept).onRefuse(onRefuse).onTimeout(onTimeout)
    }
    
}

@objc public class TimeoutableSubscriber: Timeoutable {}


extension TimeoutableSubscriber: TimeoutableSubscriberType {
    
    @discardableResult
    @objc public func onResponse(_ handler: @escaping (_ response: Any?) -> Void) -> TimeoutableSubscriberType {
        obj?.onResponse = handler
        return self
    }
    
    @discardableResult
    @objc public func onAccept(_ handler: @escaping (_ attachedData: Any?) -> Void) -> TimeoutableSubscriberType {
        obj?.onAccept = handler
        return self
    }
    
    @discardableResult
    @objc public func onRefuse(_ handler: @escaping (_ reason: Any?) -> Void) -> TimeoutableSubscriberType {
        obj?.onRefuse = handler
        return self
    }
    
    @discardableResult
    @objc public func onTimeout(_ handler: @escaping () -> Void) -> TimeoutableSubscriberType {
        obj?.onTimeout = handler
        return self
    }
    
}

extension Timeoutable: TimeoutablePublisher {
    
    @objc public func sendResponse(_ response: Any? = nil) {
        guard let handler = obj?.onResponse else { return }
        handler(response)
        obj?.invalidate()
    }
    
    @objc public func sendAccept(_ attachedData: Any? = nil) {
        guard let handler = obj?.onAccept else { return }
        handler(attachedData)
        obj?.invalidate()
    }
    
    @objc public func sendRefuse(_ reason: Any? = nil) {
        guard let handler = obj?.onRefuse else { return }
        handler(reason)
        obj?.invalidate()
    }
    
    @objc public func sendTimeout() {
        guard let handler = obj?.onTimeout else { return }
        handler()
        obj?.invalidate()
    }
    
}
