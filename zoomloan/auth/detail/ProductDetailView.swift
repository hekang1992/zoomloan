//
//  ProductDetailView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import Kingfisher

class ProductDetailView: BaseView {
    
    var cellBlock: ((produceModel) -> Void)?
    
    var productModel: headModel? {
        didSet {
            guard let productModel = productModel else { return }
            let logoUrl = productModel.breaking ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = productModel.signora ?? ""
            oneLabel.text = productModel.profound ?? ""
            moneyLabel.text = String(productModel.bertolini ?? 0)
        }
    }
    
    var modelArray: [produceModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var agreeLabel: UILabel = {
        let agreeLabel = UILabel()
        agreeLabel.textAlignment = .center
        agreeLabel.numberOfLines = 0
        agreeLabel.textColor = UIColor.init(hexString: "#999999")
        agreeLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        let fullText = "Please refer to the <loan agreement>, Your personal information will be strictly confidential."
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "#999999"), range: NSRange(location: 0, length: fullText.count))
        
        if let nightedRange = fullText.range(of: "<loan agreement>") {
            let nsRange = NSRange(nightedRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "#333333"), range: nsRange)
        }
        agreeLabel.isUserInteractionEnabled = true
        agreeLabel.attributedText = attributedString
        agreeLabel.isHidden = true
        return agreeLabel
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "pro_head_iamge")
        return oneImageView
    }()
    
    lazy var insImageView: UIImageView = {
        let insImageView = UIImageView()
        insImageView.image = UIImage(named: "net_icon_image")
        return insImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "pro_list_image")
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
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
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hexString: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return oneLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var listImageView: UIImageView = {
        let listImageView = UIImageView()
        listImageView.image = UIImage(named: "list_ad_image")
        return listImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(AuthListViewCell.self, forCellReuseIdentifier: "AuthListViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(agreeLabel)
        addSubview(loginBtn)
        addSubview(scrollView)
        agreeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(32)
        }
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 308, height: 42))
            make.bottom.equalTo(agreeLabel.snp.top).offset(-13)
        }
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(loginBtn.snp.top).offset(-20)
        }
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 162))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(31)
            make.size.equalTo(CGSize(width: 343, height: 470))
            make.bottom.equalToSuperview().offset(-20)
        }
                
        oneImageView.addSubview(logoImageView)
        oneImageView.addSubview(nameLabel)
        oneImageView.addSubview(oneLabel)
        oneImageView.addSubview(insImageView)
        oneImageView.addSubview(moneyLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(107)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.height.equalTo(20)
            make.left.equalTo(logoImageView.snp.right).offset(5)
        }
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(59)
            make.height.equalTo(20)
        }
        insImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 290, height: 57))
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(6)
            make.height.equalTo(58)
        }
        
        twoImageView.addSubview(listImageView)
        listImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-19)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: 11, height: 361))
        }
        
        twoImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(listImageView.snp.top)
            make.left.equalTo(listImageView.snp.left)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(listImageView.snp.bottom)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthListViewCell", for: indexPath) as! AuthListViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let model = modelArray?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = modelArray?[indexPath.row] {
            self.cellBlock?(model)
        }
    }
    
}
