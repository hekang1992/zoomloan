//
//  OrderViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit

class OrderViewController: BaseViewController {
    
    let modelArray = ["All", "Apply", "Repayment", "Finished"]
    
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.backBtn.isHidden = true
        headView.nameLabel.text = "Order List"
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(122)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(headView.snp.bottom).offset(-10)
            make.height.equalTo(55)
        }
        createOrderTabView(with: modelArray)
    }

}

extension OrderViewController {
    
    func createOrderTabView(with modelArray: [String]) {
        var previousButton: UIButton? = nil
        var buttons: [UIButton] = []
        for (index, title) in modelArray.enumerated() {
            let name = title
            let button = UIButton(type: .custom)
            button.setTitle(name, for: .normal)
            button.setTitleColor(UIColor.init(hexString: "#999999"), for: .normal)
            button.layer.cornerRadius = 19
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(700))
            scrollView.addSubview(button)
            buttons.append(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(38)
                make.centerY.equalToSuperview()
                make.width.equalTo(85)
                if let previous = previousButton {
                    make.left.equalTo(previous.snp.right).offset(10)
                } else {
                    make.left.equalToSuperview()
                }
            }
            previousButton = button
        }
        
        if let lastButton = previousButton {
            lastButton.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-10)
            }
        }
        self.buttons = buttons
        if let firstButton = buttons.first {
            buttonTapped(firstButton)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.layoutIfNeeded()
        for button in buttons {
            button.setTitleColor(UIColor.init(hexString: "#999999"), for: .normal)
            button.backgroundColor = UIColor.init(hexString: "#FFFFFF")
            button.layer.borderColor = UIColor.init(hexString: "#999999").cgColor
            button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        }
        
        sender.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        sender.layer.borderColor = UIColor.clear.cgColor
        
        addGradientBackground(to: sender)
        
        let index = sender.tag
        print("点击了第\(index)个按钮")
        self.selectedIndex = index
        
    }

    private func addGradientBackground(to button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [
            UIColor.init(hexString: "#69D4CA").cgColor,
            UIColor.init(hexString: "#5080E3").cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = button.layer.cornerRadius
        
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
