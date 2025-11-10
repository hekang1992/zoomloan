//
//  LoginView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit

let DESC_PHONE = "Please enter the phone number"
let DESC_CODE = "Please enter the verification code"
let DESC_AGREE = "Please agree to Privacy Policy"

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
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = "+63"
        numLabel.textAlignment = .center
        numLabel.textColor = UIColor.init(hexString: "#333333")
        numLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(700))
        return numLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hexString: "#666666")
        return lineView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: DESC_PHONE, attributes: [
            .foregroundColor: UIColor.init(hexString: "#999999") as Any,
            .font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
        phoneTextFiled.textColor = UIColor.init(hexString: "#333333")
        return phoneTextFiled
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
    
    lazy var codeTextFiled: UITextField = {
        let codeTextFiled = UITextField()
        codeTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: DESC_CODE, attributes: [
            .foregroundColor: UIColor.init(hexString: "#999999") as Any,
            .font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
        ])
        codeTextFiled.attributedPlaceholder = attrString
        codeTextFiled.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(600))
        codeTextFiled.textColor = UIColor.init(hexString: "#333333")
        return codeTextFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle("Send", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
        codeBtn.setBackgroundImage(UIImage(named: "cd_code_image"), for: .normal)
        return codeBtn
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
    
    lazy var voiceBtn: UIButton = {
        let voiceBtn = UIButton(type: .custom)
        voiceBtn.setImage(UIImage(named: "voic_icon_image"), for: .normal)
        return voiceBtn
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
        scrollView.addSubview(voiceBtn)
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
            make.left.equalTo(loginBtn.snp.left).offset(12)
            make.height.equalTo(18)
            make.right.equalTo(loginBtn.snp.right)
        }
        
        oneView.addSubview(numLabel)
        oneView.addSubview(lineView)
        oneView.addSubview(phoneTextFiled)
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.width.equalTo(32)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(numLabel.snp.right).offset(7)
            make.size.equalTo(CGSize(width: 1, height: 23))
            make.centerY.equalToSuperview()
        }
        phoneTextFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(lineView.snp.right).offset(7)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        twoView.addSubview(codeBtn)
        twoView.addSubview(codeTextFiled)
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 80, height: 35))
        }
        codeTextFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.right.equalTo(codeBtn.snp.left).offset(-10)
        }
        voiceBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(agreementView.snp.bottom).offset(34)
            make.size.equalTo(CGSize(width: 177, height: 24))
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
