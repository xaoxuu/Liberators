//
//  ViewController.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/6.
//

import UIKit
import Liberators

class ViewController: UIViewController {

    @IBOutlet weak var stack1: UIStackView!
    
    @IBOutlet weak var slider1: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

