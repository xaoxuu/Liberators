//
//  TestCodeThrottleVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import Liberators
import ProHUD

class TestCodeThrottleVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CodeThrottle"
        view.backgroundColor = .white
        
        list.add(title: "独占冷却时间") { section in
            section.add(title: "独占3s冷却") {
                CodeThrottle(timeout: 3) {
                    CountDownCapsule(.countdown(3).title("已执行"))
                } onThrottling: {
                    Capsule(.middle.duration(0).title("正在冷却中"))
                }
            }
        }
        
        list.add(title: "共享冷却时间") { section in
            let id = "shared-cooldown-a"
            section.add(title: "共享1s冷却") {
                CodeThrottle(identifier: id, timeout: 1) {
                    CountDownCapsule(.countdown(1).title("已执行1"))
                } onThrottling: {
                    Capsule(.middle.duration(0).title("正在冷却中1"))
                }
            }
            section.add(title: "共享2s冷却") {
                CodeThrottle(identifier: id, timeout: 2) {
                    CountDownCapsule(.countdown(2).title("已执行2"))
                } onThrottling: {
                    Capsule(.middle.duration(0).title("正在冷却中2"))
                }
            }
            section.add(title: "共享3s冷却") {
                CodeThrottle(identifier: id, timeout: 3) {
                    CountDownCapsule(.countdown(3).title("已执行3"))
                } onThrottling: {
                    Capsule(.middle.duration(0).title("正在冷却中3"))
                }
            }
        }
        
    }
    

}
