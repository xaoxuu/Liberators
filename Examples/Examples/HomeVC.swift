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
        navigationItem.leftBarButtonItem = .init(title: "\(Bundle.main.infoDictionary?["CFBundleName"] ?? "")", style: .done, target: self, action: #selector(self.onTappedLeftBarButtonItem(_:)))
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
        // Do any additional setup after loading the view.
        // debounce/throttle
        // Publishers.Debounce
        // Publishers.Throttle
        // CodeDebounce
        // CodeThrottle
        // CodeRetryer
        for (i, btn) in stack1.arrangedSubviews.compactMap({ $0 as? UIButton }).enumerated() {
            
            btn.setTitleColor(.lightText, for: .normal)
            switch i {
            case 0:
                btn.backgroundColor = UIColor("#2196f3")
            case 1:
                btn.backgroundColor = UIColor("#2196f3")
            case 2:
                btn.backgroundColor = UIColor("#2196f3")
            default:
                break
            }
        }
        
    }


    @IBAction func onSlide(_ sender: UISlider) {
        guard let btn = stack1.arrangedSubviews.first as? UIButton else { return }
        let value = CGFloat(sender.value)
        let color = UIColor("#2196f3aa").withBrightnessComponent(0.7)
        
        btn.backgroundColor = color.lighten(value)
        
        if sender.value < 0.7 {
            btn.setTitleColor(.white, for: .normal)
        } else {
            btn.setTitleColor(.darkText, for: .normal)
        }
        
    }
    
}

