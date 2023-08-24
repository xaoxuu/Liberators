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

        title = "Timeoutable"
        view.backgroundColor = .white
        
        var id = 0
        var idStr: String { "\(id)" }
        list.add(title: "") { section in
            var str = idStr
            section.add(title: "设置一次性临时观察者(3s超时)") {
                id += 1
                str = idStr
                Capsule("已设置观察者\(str)")
                Timeoutable(str).subscribe(timeout: 3) { response in
                    Toast("观察者\(str)收到了响应：\(response ?? "")")
                } onTimeout: {
                    Toast("观察者\(str)超时未收到响应")
                }
            }
            section.add(title: "发送响应") {
                Timeoutable(str).sendResponse(123)
            }
        }
        
        list.add(title: "") { section in
            var str = idStr
            section.add(title: "设置一次性临时观察者(10s超时)") {
                id += 1
                str = idStr
                Capsule("已设置观察者\(str)")
                Timeoutable(str).subscribe(timeout: 10) { attachedData in
                    Toast("观察者\(str)收到接受请求：\(attachedData ?? "")")
                } onRefuse: { reason in
                    Toast("观察者\(str)收到拒绝请求：\(reason ?? "")")
                } onTimeout: {
                    Toast("观察者\(str)超时未收到响应")
                }
            }
            section.add(title: "接受请求") {
                Timeoutable(str).sendAccept("haha")
            }
            section.add(title: "拒绝请求") {
                Timeoutable(str).sendRefuse(nil)
            }
        }
        
        list.add(title: "子类") { section in
            section.add(title: "设置观察者子类(3s超时)") {
                Capsule("已设置观察者子类")
                MyTimeoutable("a").subscribe(timeout: 3) { response in
                    Toast("观察者子类收到响应：\(response ?? "")")
                } onTimeout: {
                    Toast("观察者子类超时未收到响应")
                }
            }
            section.add(title: "发送响应") {
                MyTimeoutable("a").sendResponse()
            }
            section.add(title: "提前超时") {
                MyTimeoutable("a").sendTimeout()
            }
        }
        
        list.add(title: "") { section in
            section.add(title: "提前超时") {
                Timeoutable(idStr).sendTimeout()
            }
        }
        
    }
    

}

class MyTimeoutable: Timeoutable {
    override var prefix: String {
        "prefix-"
    }
}
