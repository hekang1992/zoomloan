//
//  InputViewCell.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit

class InputViewCell: UITableViewCell {
    
    var model: scrupulousModel? {
        didSet {
            guard let model = model else { return }
            let name = model.jealously ?? ""
            nameLabel.text = name
            numTextField.placeholder = name
            numTextField.text = model.importance ?? ""
        }
    }
    
    var authModel: superiorityModel? {
        didSet {
            guard let authModel = authModel else { return }
            nameLabel.text = authModel.affray ?? ""
            numTextField.placeholder = authModel.sternly ?? ""
            numTextField.text = authModel.impunity ?? ""
            let displayed = authModel.displayed ?? 0
            
            numTextField.keyboardType = displayed == 1 ? .numberPad : .default
        }
    }
    
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
        numTextField.delegate = self
        numTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return numTextField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(numTextField)
        
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
        
        numTextField.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == numTextField {
            let currentText = textField.text ?? ""
            model?.importance = currentText
            authModel?.impunity = currentText
            authModel?.odd = currentText
        }
    }
    
}
