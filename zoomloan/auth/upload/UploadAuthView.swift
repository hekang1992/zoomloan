//
//  UploadAuthView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UploadAuthView: BaseView {
    
    var photoBlock: ExampleBlock?
    var faceBlock: ExampleBlock?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bgView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        nextBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return nextBtn
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "pla_desc_image")
        bgImageView.contentMode = .scaleAspectFit
        return bgImageView
    }()
    
    lazy var oneListView: UploadListView = {
        let oneListView = UploadListView()
        oneListView.nameLabel.text = "Upload your identification document"
        oneListView.descImageView.image = UIImage(named: "pla_id_image")
        oneListView.descLabel.text = "Please take a clear photo of your own ID card front."
        oneListView.loginBtn.setTitle("Upload", for: .normal)
        return oneListView
    }()
    
    lazy var twoListView: UploadListView = {
        let twoListView = UploadListView()
        twoListView.nameLabel.text = "Face recognition"
        twoListView.descImageView.image = UIImage(named: "pla_fa_image")
        twoListView.descLabel.text = "Please face the camera directly."
        twoListView.loginBtn.setTitle("Start facial recognition", for: .normal)
        return twoListView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nextBtn)
        addSubview(scrollView)
        scrollView.addSubview(bgImageView)
        scrollView.addSubview(oneListView)
        scrollView.addSubview(twoListView)
        
        bgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(83)
        }
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 308, height: 42))
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bgView.snp.top).offset(-5)
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 141))
        }
        oneListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 343, height: 265))
        }
        twoListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneListView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 343, height: 265))
            make.bottom.equalToSuperview().offset(-10)
        }
        
        oneListView.loginBtn.rx.tap.bind(onNext: { [weak self] in
            self?.photoBlock?()
        }).disposed(by: disposeBag)
        
        twoListView.loginBtn.rx.tap.bind(onNext: { [weak self] in
            self?.faceBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
