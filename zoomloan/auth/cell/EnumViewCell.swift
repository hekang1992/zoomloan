//
//  EnumViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EnumViewCell: UITableViewCell {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var clickBlock: (() -> Void)?
    
    var model: scrupulousModel? {
        didSet {
            updateUIWithModel()
        }
    }
    
    var authModel: superiorityModel? {
        didSet {
            updateUIWithAuthModel()
        }
    }
    
    // MARK: - UI Components
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#666666")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(hexString: "#EFFCFF")
        bgView.layer.cornerRadius = 9
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var numTextField: UITextField = {
        let numTextField = UITextField()
        numTextField.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        numTextField.textColor = UIColor.init(hexString: "#59BDB7")
        numTextField.backgroundColor = .clear
        numTextField.layer.cornerRadius = 14
        numTextField.clipsToBounds = true
        numTextField.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        numTextField.leftViewMode = .always
        numTextField.isUserInteractionEnabled = false
        return numTextField
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "click_icon_right_image")
        return rightImageView
    }()
    
    lazy var cilciBtn: UIButton = {
        let cilciBtn = UIButton(type: .custom)
        return cilciBtn
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
private extension EnumViewCell {
    func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(rightImageView)
        bgView.addSubview(numTextField)
        contentView.addSubview(cilciBtn)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(22)
            make.size.equalTo(CGSize(width: 300, height: 16))
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        numTextField.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-10)
        }
        
        cilciBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindActions() {
        cilciBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.clickBlock?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Data Update Methods
private extension EnumViewCell {
    func updateUIWithModel() {
        guard let model = model else { return }
        let name = model.jealously ?? ""
        nameLabel.text = name
        numTextField.placeholder = name
        numTextField.text = model.importance ?? ""
    }
    
    func updateUIWithAuthModel() {
        guard let authModel = authModel else { return }
        nameLabel.text = authModel.affray ?? ""
        numTextField.placeholder = authModel.sternly ?? ""
        numTextField.text = authModel.impunity ?? ""
    }
}
