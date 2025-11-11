//
//  PopLogOutView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopLogOutView: BaseView {
    
    var sureBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_out_image")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(sureBtn)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(forkBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 311, height: 282))
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
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        forkBtn.rx.tap.bind(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.bind(onNext: { [weak self] in
            self?.sureBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
