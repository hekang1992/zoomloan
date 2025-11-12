//
//  FormViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FormViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var relationBlock: ((eyeModel) -> Void)?
    var phoneBlock: ((eyeModel) -> Void)?
    
    
    
    var model: eyeModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.affray ?? ""
            relaTextFiled.placeholder = model.gaiety ?? ""
            nameTextFiled.placeholder = model.loose ?? ""
            
            
            
            let name = model.choler ?? ""
            let phone = model.contrary ?? ""
            
            let allName = name + "-" + phone
            nameTextFiled.text = allName == "-" ? "" : allName
            
            let cholerDict: [String: String] = [
                "1": "Parent",
                "2": "Spouse",
                "3": "Child",
                "4": "Sibling",
                "5": "Friend",
                "6": "Colleague",
                "7": "Other"
            ]
            
            let clouded = model.clouded ?? ""
            if let choler = cholerDict[clouded] {
                relaTextFiled.text = choler
            }
        }
    }
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#666666")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(hexString: "#EFFCFF")
        bgView.layer.cornerRadius = 9
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var relaTextFiled: UITextField = {
        let relaTextFiled = UITextField()
        relaTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        relaTextFiled.textColor = UIColor.init(hexString: "#59BDB7")
        relaTextFiled.backgroundColor = .clear
        relaTextFiled.layer.cornerRadius = 14
        relaTextFiled.clipsToBounds = true
        relaTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        relaTextFiled.leftViewMode = .always
        return relaTextFiled
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "click_icon_right_image")
        rightImageView.contentMode = .scaleAspectFit
        return rightImageView
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor.init(hexString: "#333333")
        twoLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(400))
        return twoLabel
    }()
    
    lazy var anotherBgView: UIView = {
        let anotherBgView = UIView()
        anotherBgView.backgroundColor = UIColor.init(hexString: "#EFFCFF")
        anotherBgView.layer.cornerRadius = 9
        anotherBgView.layer.masksToBounds = true
        return anotherBgView
    }()
    
    lazy var nameTextFiled: UITextField = {
        let nameTextFiled = UITextField()
        nameTextFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        nameTextFiled.textColor = UIColor.init(hexString: "#59BDB7")
        nameTextFiled.backgroundColor = .clear
        nameTextFiled.layer.cornerRadius = 14
        nameTextFiled.clipsToBounds = true
        nameTextFiled.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        nameTextFiled.leftViewMode = .always
        return nameTextFiled
    }()
    
    lazy var rightIconImageView: UIImageView = {
        let rightIconImageView = UIImageView()
        rightIconImageView.image = UIImage(named: "phone_lis_ios_image")
        rightIconImageView.contentMode = .scaleAspectFit
        return rightIconImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(relaTextFiled)
        bgView.addSubview(rightImageView)
        
        contentView.addSubview(anotherBgView)
        anotherBgView.addSubview(nameTextFiled)
        anotherBgView.addSubview(rightIconImageView)
        
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        relaTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
        
        
        anotherBgView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        rightIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        nameTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightIconImageView.snp.left).offset(-10)
        }
        
        bgView.addSubview(oneBtn)
        anotherBgView.addSubview(twoBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            self.relationBlock?(model)
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = model else { return }
            self.phoneBlock?(model)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
