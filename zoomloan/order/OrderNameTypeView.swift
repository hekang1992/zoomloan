//
//  OrderNameTypeView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import SnapKit

class OrderNameTypeView: UIView {
    
    // MARK: - Properties
    var model: stoppedModel? {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI Components
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .right
        return twoLabel
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension OrderNameTypeView {
    func setupUI() {
        addSubview(oneLabel)
        addSubview(twoLabel)
    }
    
    func setupConstraints() {
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
    }
    
    func updateUI() {
        guard let model = model else { return }
        oneLabel.text = model.affray ?? ""
        twoLabel.text = model.rested ?? ""
    }
}
