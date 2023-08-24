//
//  HomeVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/6.
//

import UIKit
import Liberators
import ProHUD

class HomeVC: ListVC {

    @IBOutlet weak var stack1: UIStackView!
    
    @IBOutlet weak var slider1: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "questionmark.circle.fill"), style: .done, target: self, action: #selector(self.onTappedRightBarButtonItem(_:)))
        
        title = "Liberators"
        
        func push(_ vc: UIViewController) {
            navigationController?.pushViewController(vc, animated: true)
        }
        
        list.add(title: "代码工具") { section in
            section.add(title: "CodeThrottle: 代码节流（冷却）器") {
                let vc = TestCodeThrottleVC()
                push(vc)
            }
            section.add(title: "CodeDebounce: 代码防抖器") {
                let vc = TestCodeDebounceVC()
                push(vc)
            }
            section.add(title: "CodeRetryable: 代码重试器") {
                let vc = TestCodeRetryableVC()
                push(vc)
            }
        }
        
        list.add(title: "Foundation工具") { section in
            section.add(title: "TimeoutableObserver: 一次性临时观察者") {
                let vc = TestTimeoutableObserverVC()
                push(vc)
            }
        }
        
        list.add(title: "UI工具") { section in
            section.add(title: "调色工具") {
                let vc = TestColorVC()
                push(vc)
            }
        }
        
        
    }
    
}

