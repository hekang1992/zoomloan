//
//  UploadListView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit

class UploadListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#EFFCFF")
        return bgView
    }()

    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "pla_suc_main_image")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return whiteView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.contentMode = .scaleAspectFit
        return descImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.init(hexString: "#666666")
        descLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        return descLabel
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)        
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "up_load_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var asoImageView: UIImageView = {
        let asoImageView = UIImageView()
        asoImageView.image = UIImage(named: "pla_suc_fock_image")
        asoImageView.contentMode = .scaleAspectFit
        asoImageView.isHidden = true
        return asoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(logoImageView)
        bgView.addSubview(whiteView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 266))
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        whiteView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(219)
        }
        
        bgView.addSubview(nameLabel)
        whiteView.addSubview(descImageView)
        whiteView.addSubview(asoImageView)
        whiteView.addSubview(descLabel)
        whiteView.addSubview(loginBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.height.equalTo(17)
        }
        descImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(32)
            make.size.equalTo(CGSize(width: 202, height: 108))
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(12)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 272, height: 39))
        }
        asoImageView.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.top).offset(-10)
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.right.equalTo(descImageView.snp.right).offset(9)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
