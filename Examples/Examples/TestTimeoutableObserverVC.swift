//
//  TestTimeoutableObserverVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import Liberators
import ProHUD

class TestTimeoutableObserverVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TimeoutableObserver"
        view.backgroundColor = .white
        
        list.add(title: "") { section in
            section.add(title: "设置一次性临时观察者(3s超时)") {
                TimeoutableObserver("a", timeout: 3) { response in
                    Capsule("收到了响应：\(response ?? "")")
                } onTimeout: {
                    Capsule("超时未响应")
                }
            }
            section.add(title: "发送响应") {
                TimeoutableObserver.onResponse("a", object: 123)
            }
        }
        
    }
    

}
