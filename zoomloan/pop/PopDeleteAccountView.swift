//
//  PopDeleteAccountView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopDeleteAccountView: BaseView {
    
    var sureBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?
    
    let isAgreed = BehaviorRelay<Bool>(value: false)
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "dele_icon-image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        return sureBtn
    }()

    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var forkBtn: UIButton = {
        let forkBtn = UIButton(type: .custom)
        return forkBtn
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "agr_image_nor"), for: .normal)
        button.setImage(UIImage(named: "agr_image_sel"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "I am already aware of the above information."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        label.textColor = UIColor.init(hexString: "#333333")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(sureBtn)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(forkBtn)
        bgImageView.addSubview(checkButton)
        bgImageView.addSubview(agreementLabel)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 311, height: 525))
        }
        
        forkBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        sureBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(forkBtn.snp.top)
            make.size.equalTo(CGSize(width: 155, height: 60))
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(forkBtn.snp.top)
            make.size.equalTo(CGSize(width: 155, height: 60))
        }
        
        checkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-137)
            make.left.equalToSuperview().offset(36)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        agreementLabel.snp.makeConstraints { make in
            make.top.equalTo(checkButton.snp.top).offset(-2)
            make.right.equalToSuperview().offset(-36)
            make.left.equalTo(checkButton.snp.right).offset(5)
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        forkBtn.rx.tap.bind(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.bind(onNext: { [weak self] in
            self?.sureBlock?()
        }).disposed(by: disposeBag)
        
        checkButton.rx.tap
            .map { [weak self] in !(self?.checkButton.isSelected ?? false) }
            .bind { [weak self] isSelected in
                self?.checkButton.isSelected = isSelected
                self?.isAgreed.accept(isSelected)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
