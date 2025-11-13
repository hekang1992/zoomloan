//
//  LampView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxGesture
import RxCocoa

class LampView: BaseView {
    
    var headBlock: ((chairsModel) -> Void)?
    
    var cellClickBlock: ((chairsModel) -> Void)?
    
    var model: chairsModel? {
        didSet {
            guard let model = model else { return }
            
            let logoUrl = model.breaking ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.profound ?? ""
            oneLabel.text = model.goes ?? ""
            moneyLabel.text = model.going ?? ""
            loginBtn.setTitle(model.illusion ?? "", for: .normal)
        }
    }
    
    var modelArray: [chairsModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            changShowListView(with: modelArray)
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        return bgImageView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var headImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "lam_icon_image")
        oneImageView.isUserInteractionEnabled = true
        return oneImageView
    }()
    
    private lazy var insImageView: UIImageView = {
        let insImageView = UIImageView()
        insImageView.image = UIImage(named: "net_icon_image")
        return insImageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#4BA5B6")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    private lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hexString: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return oneLabel
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "lamp_desc_ic_image")
        return descImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        whiteView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return whiteView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(scrollView)
        scrollView.addSubview(headImageView)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-2)
        }
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 343, height: 221))
        }
        
        headImageView.addSubview(logoImageView)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(oneLabel)
        headImageView.addSubview(insImageView)
        headImageView.addSubview(moneyLabel)
        headImageView.addSubview(loginBtn)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(107)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.height.equalTo(20)
            make.left.equalTo(logoImageView.snp.right).offset(5)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(59)
            make.height.equalTo(20)
        }
        
        insImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 290, height: 57))
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(6)
            make.height.equalTo(58)
        }
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 272, height: 48))
        }
        
        scrollView.addSubview(descImageView)
        descImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 343, height: 49))
            make.centerX.equalToSuperview()
            make.top.equalTo(headImageView.snp.bottom).offset(15)
        }
        
        scrollView.insertSubview(whiteView, belowSubview: descImageView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(-5)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        headImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self, let model = model else { return }
            self.headBlock?(model)
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            self.headBlock?(model)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LampView {
    
    private func changShowListView(with modelArray: [chairsModel]) {
        
        
        whiteView.subviews.forEach { $0.removeFromSuperview() }
        
        guard !modelArray.isEmpty else { return }
        
        var previousView: LampListView?
        
        for (index, model) in modelArray.enumerated() {
            let listView = LampListView()
            listView.model = model
            whiteView.addSubview(listView)
            listView.cellClickBlock = { [weak self] model in
                self?.cellClickBlock?(model)
            }
            listView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(89)
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(12)
                } else {
                    make.top.equalToSuperview().offset(10)
                }
                if index == modelArray.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-12)
                }
            }
            previousView = listView
        }
        
        
    }
    
}
