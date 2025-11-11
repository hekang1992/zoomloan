//
//  HomeView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
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
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(13)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
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
