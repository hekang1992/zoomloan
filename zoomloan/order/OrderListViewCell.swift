//
//  OrderListViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import SnapKit
import Kingfisher

class OrderListViewCell: UITableViewCell {
    
    var model: reallyModel? {
        didSet {
            guard let model = model else { return }
            
            let modelArray = model.stopped ?? []
            issueLabel.text = model.illusion ?? ""
            self.layerListView(with: modelArray)
            
            let logoUrl = model.breaking ?? ""
            let name = model.profound ?? ""
            
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            orLabel.text = name
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "orc_icon_image")
        return bgImageView
    }()
    
    lazy var typeView: UIView = {
        let typeView = UIView()
        typeView.layer.cornerRadius = 9
        typeView.layer.masksToBounds = true
        typeView.backgroundColor = UIColor.init(hexString: "#0CBAE3")
        typeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return typeView
    }()
    
    lazy var issueLabel: UILabel = {
        let issueLabel = UILabel()
        issueLabel.textAlignment = .center
        issueLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        issueLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return issueLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        return whiteView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var orLabel: UILabel = {
        let orLabel = UILabel()
        orLabel.textAlignment = .left
        orLabel.textColor = UIColor.init(hexString: "#4BA5B6")
        orLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return orLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgView)
        bgView.addSubview(typeView)
        bgView.addSubview(whiteView)
        contentView.addSubview(bgImageView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        bgImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 228, height: 44))
            make.right.equalTo(bgView.snp.right)
            make.top.equalToSuperview()
        }
        
        typeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.height.equalTo(23)
        }
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(typeView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        typeView.addSubview(issueLabel)
        issueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(orLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        orLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderListViewCell {
    
    private func layerListView(with modelArray: [stoppedModel]) {
        
        whiteView.subviews.forEach { $0.removeFromSuperview() }
        
        guard !modelArray.isEmpty else { return }
        
        var previousView: OrderNameTypeView?
        
        for (index, model) in modelArray.enumerated() {
            let listView = OrderNameTypeView()
            listView.model = model
            whiteView.addSubview(listView)
            
            if index == 0 {
                listView.twoLabel.textColor = UIColor.init(hexString: "#333333")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(600))
            }else {
                listView.twoLabel.textColor = UIColor.init(hexString: "#333333")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(600))
            }
            
            listView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(14)
                
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

