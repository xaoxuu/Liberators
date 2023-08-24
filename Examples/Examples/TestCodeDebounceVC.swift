//
//  TestCodeDebounceVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import ProHUD
import Liberators

class TestCodeDebounceVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CodeDebounce"
        view.backgroundColor = .white
        
        list.add(title: "") { section in
            section.add(title: "防抖0.5s") {
                CodeDebounce(delay: 0.5) {
                    Capsule("已执行")
                } onWaiting: {
                    Capsule(.middle.duration(0).title("正在推迟"))
                }
            }
        }
        
    }
    

}
