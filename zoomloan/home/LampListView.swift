//
//  LampListView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class LampListView: BaseView {
    
    var cellClickBlock: ((chairsModel) -> Void)?
    
    var model: chairsModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.breaking ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.profound ?? ""
            appLabel.text = model.illusion ?? ""
            descLabel.text = model.goes ?? ""
            moneyLabel.text = model.going ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "lamp_list_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
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

    lazy var appImageView: UIImageView = {
        let appImageView = UIImageView()
        appImageView.image = UIImage(named: "desc_image_co_ad")
        return appImageView
    }()
    
    private lazy var appLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.textAlignment = .center
        appLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        appLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        return appLabel
    }()
    
    private lazy var descLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.textAlignment = .left
        appLabel.textColor = UIColor.init(hexString: "#666666")
        appLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(700))
        return appLabel
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .right
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(700))
        return moneyLabel
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(appImageView)
        appImageView.addSubview(appLabel)
        addSubview(loginBtn)
        bgImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 311, height: 89))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.height.equalTo(20)
        }
        appImageView.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 82, height: 28))
        }
        appLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgImageView.addSubview(descLabel)
        bgImageView.addSubview(moneyLabel)
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.left)
            make.top.equalTo(logoImageView.snp.bottom).offset(17)
            make.height.equalTo(20)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(24)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            self.cellClickBlock?(model)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
