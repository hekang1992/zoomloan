//
//  LoginView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit

class LoginView: BaseView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo_desc_image")
        return logoImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "Telephone Number"
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return phoneLabel
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        oneView.layer.cornerRadius = 20
        oneView.layer.masksToBounds = true
        return oneView
    }()
    
    lazy var codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.text = "Verification Code"
        codeLabel.textAlignment = .left
        codeLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        codeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return codeLabel
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        twoView.layer.cornerRadius = 20
        twoView.layer.masksToBounds = true
        return twoView
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in to Zoom Loan", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var agreementView: AgreementView = {
        let agreementView = AgreementView()
        return agreementView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(oneView)
        scrollView.addSubview(codeLabel)
        scrollView.addSubview(twoView)
        scrollView.addSubview(loginBtn)
        scrollView.addSubview(agreementView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(96)
            make.size.equalTo(CGSize(width: 114, height: 114))
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(45)
            make.left.equalToSuperview().offset(29)
            make.height.equalTo(17)
        }
        oneView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(29)
            make.height.equalTo(17)
        }
        twoView.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 314, height: 48))
        }
        agreementView.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(31)
            make.left.equalTo(loginBtn.snp.left)
            make.height.equalTo(18)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
