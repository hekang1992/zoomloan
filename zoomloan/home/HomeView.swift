//
//  HomeView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import Kingfisher
import RxGesture
import RxSwift
import RxCocoa

class HomeView: BaseView {
    
    var applyBlock: ((chairsModel) -> Void)?

    var model: chairsModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.breaking ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.profound ?? ""
            let descText = model.goes ?? ""
            oneLabel.text = "\(descText)(₱)"
            moneyLabel.text = model.going ?? ""
            
            oneListView.bgImageView.image = UIImage(named: "home_rate_image")
            oneListView.oneLabel.text = model.explain ?? ""
            oneListView.twoLabel.text = model.hereafter ?? ""
            
            twoListView.bgImageView.image = UIImage(named: "home_item_image")
            twoListView.oneLabel.text = model.relate ?? ""
            twoListView.twoLabel.text = model.extraordinary ?? ""
            
            let illusion = model.illusion ?? ""
            loginBtn.setTitle(illusion, for: .normal)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "home_one_image")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "home_two_image")
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "home_three_image")
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "home_four_image")
        return fourImageView
    }()
    
    lazy var fiveImageView: UIImageView = {
        let fiveImageView = UIImageView()
        fiveImageView.image = UIImage(named: "home_five_image")
        return fiveImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#4BA5B6")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hexString: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return oneLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var oneListView: HomeTermView = {
        let oneListView = HomeTermView()
        return oneListView
    }()
    
    lazy var twoListView: HomeTermView = {
        let twoListView = HomeTermView()
        return twoListView
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(fourImageView)
        scrollView.addSubview(fiveImageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        oneImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(550)
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.top).offset(226)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 397))
        }
        threeImageView.snp.makeConstraints { make in
            make.bottom.equalTo(twoImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 117))
        }
        fourImageView.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 362, height: 310))
        }
        fiveImageView.snp.makeConstraints { make in
            make.top.equalTo(fourImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 324))
            make.bottom.equalToSuperview().offset(-10)
        }
        
        twoImageView.addSubview(logoImageView)
        twoImageView.addSubview(nameLabel)
        twoImageView.addSubview(oneLabel)
        twoImageView.addSubview(moneyLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(13)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(19)
        }
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(61)
            make.height.equalTo(20)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(6)
            make.height.equalTo(58)
        }
        
        twoImageView.addSubview(oneListView)
        twoImageView.addSubview(twoListView)
        twoImageView.addSubview(loginBtn)
        
        oneListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(moneyLabel.snp.bottom).offset(13)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(20)
        }
        twoListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(oneListView.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(20)
        }
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 272, height: 48))
            make.top.equalTo(twoListView.snp.bottom).offset(15)
        }
        
        twoImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self, let model = model else { return }
            self.applyBlock?(model)
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            self.applyBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("bottom======\(self.safeAreaInsets.bottom)")
    }
    
}
