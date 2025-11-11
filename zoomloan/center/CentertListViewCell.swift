//
//  CentertListViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import Kingfisher

class CentertListViewCell: UITableViewCell {
    
    var model: reallyModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.searched ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.affray ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(hexString: "#F9F9F9")
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#F5F5F5").cgColor
        return bgView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "click_icon_right_image")
        return rightImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(rightImageView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 21, height: 21))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
