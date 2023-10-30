//
//  TestCodeRetryableVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import Liberators
import ProHUD

class TestCodeRetryableVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CodeRetryable"
        view.backgroundColor = .white
        
        list.add(title: "同步重试（请看控制台输出）") { section in
            section.add(title: "未设置次数上限（默认3次重试）") {
                var i = 0
                CodeRetryable { retryer in
                    i += 1
                    print(">>> 第\(i)次执行")
                    retryer.continue()
                } onLimitReached: {
                    print(">>> 已经达到重试次数上限")
                }
            }
            section.add(title: "未超出次数上限") {
                var i = 0
                CodeRetryable(limitTimes: 5) { retryer in
                    i += 1
                    print(">>> 第\(i)次执行")
                    if i < 3 {
                        retryer.continue()
                    } else {
                        retryer.invalidate()
                    }
                } onLimitReached: {
                    print(">>> 已经达到重试次数上限")
                }
            }
            section.add(title: "超出次数上限") {
                var i = 0
                CodeRetryable(limitTimes: 5) { retryer in
                    i += 1
                    print(">>> 第\(i)次执行")
                    retryer.continue()
                } onLimitReached: {
                    print(">>> 已经达到重试次数上限")
                }
            }
        }
        
        list.add(title: "异步重试（间隔1s）") { section in
            section.add(title: "未设置次数上限（默认3次重试）") {
                var i = 0
                CodeRetryable { retryer in
                    i += 1
                    Capsule(.middle.title("第\(i)次执行").duration(0))
                    retryer.continue(queue: .main, after: 1)
                } onLimitReached: {
                    Capsule("已经达到重试次数上限")
                }
            }
            section.add(title: "未超出次数上限") {
                var i = 0
                CodeRetryable(limitTimes: 5) { retryer in
                    i += 1
                    Capsule(.middle.title("第\(i)次执行").duration(0))
                    if i < 3 {
                        retryer.continue(queue: .main, after: 1)
                    } else {
                        retryer.invalidate()
                    }
                } onLimitReached: {
                    Capsule("已经达到重试次数上限")
                }
            }
            section.add(title: "超出次数上限") {
                var i = 0
                CodeRetryable(limitTimes: 5) { retryer in
                    i += 1
                    Capsule(.middle.title("第\(i)次执行").duration(0))
                    retryer.continue(queue: .main, after: 1)
                } onLimitReached: {
                    Capsule("已经达到重试次数上限")
                }
            }
        }
        list.add(title: "在其他地方重试") { section in
            section.add(title: "设置重试代码，不立即执行") {
                var i = 0
                CodeRetryable(identifier: "retry-action", limitTimes: 5, runItImmediately: false) { retryer in
                    i += 1
                    Capsule(.middle.title("第\(i)次执行").duration(0))
                } onLimitReached: {
                    Capsule("已经达到重试次数上限")
                }
            }
            section.add(title: "立即重试") {
                CodeRetryable.find(identifier: "retry-action")?.continue()
            }
            section.add(title: "立即失效（并释放内存）") {
                CodeRetryable.find(identifier: "retry-action")?.invalidate()
            }
        }
        
        list.add(title: "重试过程中取消") { section in
            section.add(title: "设置重试代码，不立即执行") {
                var i = 0
                CodeRetryable(identifier: "retry2", limitTimes: 5, runItImmediately: false) { retryer in
                    i += 1
                    Capsule(.middle.title("第\(i)次执行").duration(0))
                } onLimitReached: {
                    Capsule("已经达到重试次数上限")
                }
            }
            section.add(title: "设置2s后重试") {
                CodeRetryable.find(identifier: "retry2")?.continue(queue: .main, after: 2)
            }
            section.add(title: "立即失效（并释放内存）") {
                CodeRetryable.find(identifier: "retry2")?.invalidate()
            }
        }
        
    }

}
