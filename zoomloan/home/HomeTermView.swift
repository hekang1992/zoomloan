//
//  HomeTermView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit

class HomeTermView: UIView {

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        return bgImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#999999")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .right
        twoLabel.textColor = UIColor.init(hexString: "#EB6654")
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return twoLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(oneLabel)
        addSubview(twoLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.left.equalToSuperview()
        }
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(bgImageView.snp.right).offset(3)
            make.height.equalTo(20)
        }
        twoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
