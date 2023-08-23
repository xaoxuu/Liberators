//
//  HUDExts.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import ProHUD

extension CapsuleViewModel {
    static func countdown(_ value: TimeInterval?) -> CapsuleViewModel {
        .icon(.init(systemName: "clock.fill"))
        .duration(value)
    }
}

open class CountDownCapsule: HUDProviderType {
    
    public typealias ViewModel = CapsuleViewModel
    public typealias Target = CapsuleTarget
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码（传空值时不会做任何事）
    @discardableResult public required init(initializer: ((_ target: Target) -> Void)?) {
        guard let initializer = initializer else {
            // Provider的作用就是push一个target
            // 如果没有任何初始化代码就没有target，就是个无意义的Provider
            // 但为了支持lazyPush（找到已有实例并更新），所以就需要支持无意义的Provider
            // 详见子类中的 self.init(initializer: nil)
            return
        }
        let t = Target()
        initializer(t)
        t.push()
        if let vm = t.vm {
            let value = Int64(vm.duration ?? 1)
            let count = value * 10
            if count > 0 {
                let progress = Progress(totalUnitCount: count)
                for i in 1 ... count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(count - i) * 0.1) {
                        progress.completedUnitCount = i
                        t.update(progress: progress.fractionCompleted)
                    }
                }
            }
        }
    }
    
    /// 根据ViewModel和自定义的初始化代码创建一个Target并显示
    /// - Parameters:
    ///   - vm: 数据模型
    ///   - initializer: 初始化代码
    @discardableResult public convenience init(_ vm: ViewModel, initializer: ((_ capsule: Target) -> Void)?) {
        if let id = vm.identifier, id.count > 0, let target = CapsuleManager.find(identifier: id).last {
            target.update { t in
                t.vm = vm
                initializer?(t)
            }
            self.init(initializer: nil)
        } else {
            self.init { target in
                target.vm = vm
                initializer?(target)
            }
        }
    }
    
    /// 根据ViewModel创建一个Target并显示
    /// - Parameter vm: 数据模型
    @discardableResult public convenience init(_ vm: ViewModel) {
        self.init(vm, initializer: nil)
    }
    
    
    /// 根据文本作为数据模型创建一个Target并显示
    /// - Parameter text: 文本
    @discardableResult public convenience init(_ text: String) {
        self.init(.init().duration(2).message(text), initializer: nil)
    }
    
    
}
