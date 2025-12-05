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
    
    // MARK: - Properties
    var cellBlock: ((produceModel) -> Void)?
    
    var productModel: headModel? {
        didSet {
            updateProductUI()
        }
    }
    
    var modelArray: [produceModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Components
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
        agreeLabel.isUserInteractionEnabled = true
        agreeLabel.isHidden = true
        let fullText = "Please refer to the <loan agreement>, Your personal information will be strictly confidential."
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "#999999"), range: NSRange(location: 0, length: fullText.count))
        
        if let nightedRange = fullText.range(of: "<loan agreement>") {
            let nsRange = NSRange(nightedRange, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "#333333"), range: nsRange)
        }
        agreeLabel.attributedText = attributedString
        return agreeLabel
    }()
    
    private lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "pro_head_iamge")
        return oneImageView
    }()
    
    private lazy var insImageView: UIImageView = {
        let insImageView = UIImageView()
        insImageView.image = UIImage(named: "net_icon_image")
        return insImageView
    }()
    
    private lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "pro_list_image")
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#4BA5B6")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    private lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hexString: "#666666")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(700))
        return oneLabel
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    private lazy var listImageView: UIImageView = {
        let listImageView = UIImageView()
        listImageView.image = UIImage(named: "list_ad_image")
        return listImageView
    }()
    
    private lazy var tableView: UITableView = {
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
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
private extension ProductDetailView {
    func setupUI() {
        addSubview(agreeLabel)
        addSubview(loginBtn)
        addSubview(scrollView)
        
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        
        setupOneImageViewContent()
        setupTwoImageViewContent()
    }
    
    func setupConstraints() {
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
    }
    
    func setupOneImageViewContent() {
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
    }
    
    func setupTwoImageViewContent() {
        twoImageView.addSubview(listImageView)
        twoImageView.addSubview(tableView)
        
        listImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-19)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: 11, height: 361))
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(listImageView.snp.top)
            make.left.equalTo(listImageView.snp.left)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(listImageView.snp.bottom)
        }
    }
    
}

// MARK: - Data Update Methods
private extension ProductDetailView {
    func updateProductUI() {
        guard let productModel = productModel else { return }
        let logoUrl = productModel.breaking ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        nameLabel.text = productModel.profound ?? ""
        oneLabel.text = productModel.signora ?? ""
        moneyLabel.text = String(productModel.bertolini ?? 0)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProductDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthListViewCell", for: indexPath) as! AuthListViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.model = modelArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = modelArray?[indexPath.row] else { return }
        cellBlock?(model)
    }
}
