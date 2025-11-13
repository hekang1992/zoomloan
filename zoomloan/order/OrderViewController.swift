//
//  OrderViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxGesture

class OrderViewController: BaseViewController {
    
    let modelArray = ["All", "Apply", "Repayment", "Finished"]
    
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = -1
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView  = UIStackView()
        return stackView
    }()
    
    lazy var listView: OrderListView = {
        let listView = OrderListView()
        return listView
    }()

    var unusual: String = "4"
    
    lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        return emptyView
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
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(headView.snp.bottom).offset(-20)
            make.height.equalTo(55)
        }
        createOrderTabView(with: modelArray)
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(1)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-2)
        }
        
        self.listView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.listInfo(with: unusual)
        })
        
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyView.clickBlock = {
            NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
        }
        
        listView.cellBlock = { [weak self ] model in
            guard let self = self else { return }
            let pageUrl = model.earnest ?? ""
            SchemeURLManagerTool.goPageWithPageUrl(pageUrl, from: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfo(with: unusual)
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
                make.width.equalTo((UIScreen.main.bounds.size.width - 50) * 0.25)
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
            changeBtnColor(firstButton)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        changeBtnColor(sender)
        let index = sender.tag
        switch index {
        case 0:
            listInfo(with: "4")
            break
        case 1:
            listInfo(with: "7")
            break
        case 2:
            listInfo(with: "6")
            break
        case 3:
            listInfo(with: "5")
            break
        default:
            break
        }
        
    }
    
    func changeBtnColor(_ sender: UIButton) {
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

extension OrderViewController {
    
    private func listInfo(with unusual: String) {
        let viewModel = OrderListViewModel()
        self.unusual = unusual
        let json = ["unusual": unusual]
        defer {
            self.listView.tableView.mj_header?.endRefreshing()
        }
        
        Task {
            do {
                let model = try await viewModel.listOrderInfo(with: json)
                if model.sentences == "0" {
                    let modelArray = model.credulity?.really ?? []
                    self.listView.modelArray = modelArray
                    if modelArray.isEmpty {
                        self.showEmptyView()
                    }else {
                        self.hideEmptyView()
                    }
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch  {
                
            }
        }
    }
    
    private func showEmptyView() {
        emptyView.isHidden = false
    }
    
    private func hideEmptyView() {
        emptyView.isHidden = true
    }
}


class EmptyView: BaseView {
    
    var clickBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "no_list_image")
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 250, height: 250))
        }
        bgImageView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.clickBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
