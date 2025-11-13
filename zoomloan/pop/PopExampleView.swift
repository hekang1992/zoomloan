//
//  PopExampleView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

typealias ExampleBlock = () -> Void

class PopExampleView: BaseView {
    
    var cancelBlock: ExampleBlock?
    var sureBlock: ExampleBlock?
    
    // MARK: - UI Components
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        bindActions()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension PopExampleView {
    func setupUI() {
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
    }
    
    func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 311, height: 486))
        }
        
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oneBtn.snp.top).offset(-25)
            make.size.equalTo(CGSize(width: 311, height: 40))
        }
    }
    
    func bindActions() {
        oneBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.cancelBlock?()
            })
            .disposed(by: disposeBag)
        
        twoBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.sureBlock?()
            })
            .disposed(by: disposeBag)
    }
}
