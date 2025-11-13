//
//  LibraryView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LibraryView: BaseView {
    
    // MARK: - Callback Blocks
    var sureBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "library_icon_image")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let sureButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    private let forkButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Methods
private extension LibraryView {
    func setupViewHierarchy() {
        addSubview(backgroundImageView)
        [sureButton, cancelButton, forkButton].forEach {
            backgroundImageView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 311, height: 322))
        }
        
        forkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        sureButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(forkButton.snp.top)
            make.size.equalTo(CGSize(width: 155, height: 60))
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(forkButton.snp.top)
            make.size.equalTo(CGSize(width: 155, height: 60))
        }
    }
    
    func bindActions() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.cancelBlock?()
            }
            .disposed(by: disposeBag)
        
        forkButton.rx.tap
            .bind { [weak self] in
                self?.cancelBlock?()
            }
            .disposed(by: disposeBag)
        
        sureButton.rx.tap
            .bind { [weak self] in
                self?.sureBlock?()
            }
            .disposed(by: disposeBag)
    }
}
