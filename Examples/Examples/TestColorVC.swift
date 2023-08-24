//
//  TestColorVC.swift
//  Examples
//
//  Created by xaoxuu on 2023/8/23.
//

import UIKit
import Liberators

class TestColorVC: UIViewController {

    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    let sliderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    let preview: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGreen
        v.layer.cornerRadiusWithContinuous = 16
        return v
    }()
    
    var mainColor = UIColor("#2196f3")
    
    var labels: [UILabel] = []
    var sliders: [UISlider] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "调色工具"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainStack)
        let safeAreaInsets = UIWindow.appSafeAreaInsets
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeAreaInsets.top + 100)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(safeAreaInsets.bottom + 8)
        }
        
        mainStack.addArrangedSubview(infoStack)
        infoStack.addArrangedSubview(preview)
        
        mainStack.addArrangedSubview(sliderStack)
        
        for i in 0 ..< 7 {
            let lb = UILabel()
            lb.font = .systemFont(ofSize: 14)
            lb.tag = i
            labels.append(lb)
            
            let s = UISlider()
            s.tag = i
            s.minimumValue = 0
            if i == 3 {
                s.maximumValue = 0.999 // hue: 1 == 0
            } else {
                s.maximumValue = 1
            }
            sliders.append(s)
            
            labelStack.addArrangedSubview(lb)
            lb.snp.makeConstraints { make in
                make.height.equalTo(32)
                make.width.equalTo(120)
            }
            sliderStack.addArrangedSubview(s)
            s.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.addArrangedSubview(labelStack)
            stack.addArrangedSubview(sliderStack)
            infoStack.addArrangedSubview(stack)
            s.addTarget(self, action: #selector(self.onSliderValueChanged(_:)), for: .valueChanged)
            update(label: lb, slider: s)
        }
        
    }
    
    func update(label: UILabel, slider: UISlider) {
        let rgba = mainColor.rgba
        let hsba = mainColor.hsba
        switch slider.tag {
        case 0: // r
            label.text = .init(format: "red: %.2f", rgba.red)
            slider.value = Float(rgba.red)
        case 1: // g
            label.text = .init(format: "green: %.2f", rgba.green)
            slider.value = Float(rgba.green)
        case 2: // b
            label.text = .init(format: "blue: %.2f", rgba.blue)
            slider.value = Float(rgba.blue)
        case 3: // h
            label.text = .init(format: "hue: %.2f", hsba.hue)
            slider.value = Float(hsba.hue)
        case 4: // s
            label.text = .init(format: "saturation: %.2f", hsba.saturation)
            slider.value = Float(hsba.saturation)
        case 5: // b
            label.text = .init(format: "brightness: %.2f", hsba.brightness)
            slider.value = Float(hsba.brightness)
        case 6: // a
            label.text = .init(format: "alpha: %.2f", rgba.alpha)
            slider.value = Float(rgba.alpha)
        default:
            break
        }
    }

    @objc func onSliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        switch sender.tag {
        case 0: // r
            preview.backgroundColor = mainColor.withRedComponent(value)
        case 1: // g
            preview.backgroundColor = mainColor.withGreenComponent(value)
        case 2: // b
            preview.backgroundColor = mainColor.withBlueComponent(value)
        case 3: // h
            preview.backgroundColor = mainColor.withHueComponent(value)
        case 4: // s
            preview.backgroundColor = mainColor.withSaturationComponent(value)
        case 5: // b
            preview.backgroundColor = mainColor.withBrightnessComponent(value)
        case 6: // a
            preview.backgroundColor = mainColor.withAlphaComponent(value)
        default:
            break
        }
        mainColor = preview.backgroundColor ?? mainColor
        for i in 0 ..< labels.count {
            update(label: labels[i], slider: sliders[i])
        }
    }
    
}
