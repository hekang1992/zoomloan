//
//  AuthListViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import Kingfisher

class AuthListViewCell: UITableViewCell {
    
    var model: produceModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.forbade ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.affray ?? ""
            let possessed = model.possessed ?? 0
            rightImageView.image = possessed == 0 ? UIImage(named: "li_click_one_image") : UIImage(named: "li_one_right_image")
        }
    }
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "li_one_image")
        return oneImageView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(hexString: "#E0F9FF")
        bgView.layer.cornerRadius = 16
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#F5F5F5").cgColor
        return bgView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "li_one_image")
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        nameLabel.numberOfLines = 2
        return nameLabel
    }()

    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        return rightImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(oneImageView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(rightImageView)
        
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 264, height: 60))
            make.bottom.equalToSuperview().offset(-15)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 11, height: 11))
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.right.equalTo(rightImageView.snp.left).offset(-5)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 21, height: 21))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

