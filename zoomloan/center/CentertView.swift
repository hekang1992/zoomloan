//
//  CentertView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture
import RxCocoa

class CentertView: BaseView {
    
    var settingBlock: (() -> Void)?
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?
    var threeBlock: ((String) -> Void)?
    
    var modelArray: [reallyModel]?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "")
        logoImageView.backgroundColor = .systemPink
        return logoImageView
    }()
    
    lazy var settingBtn: UIButton = {
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "setting_icon_image"), for: .normal)
        return settingBtn
    }()
    
    lazy var whiteImageView: UIImageView = {
        let whiteImageView = UIImageView()
        whiteImageView.image = UIImage(named: "union_bg_image")
        whiteImageView.isUserInteractionEnabled = true
        return whiteImageView
    }()
    
    lazy var appLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.text = "Zoom Loan"
        appLabel.textAlignment = .left
        appLabel.textColor = UIColor.init(hexString: "#333333")
        appLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(700))
        return appLabel
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hexString: "#333333")
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return phoneLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CentertListViewCell.self, forCellReuseIdentifier: "CentertListViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(settingBtn)
        settingBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-35)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(settingBtn.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 72, height: 72))
        }
        
        addSubview(appLabel)
        appLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.top).offset(12)
            make.left.equalTo(logoImageView.snp.right).offset(15)
            make.height.equalTo(23)
        }
        
        addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(logoImageView.snp.bottom).offset(-12)
            make.left.equalTo(appLabel.snp.left)
            make.height.equalTo(17)
        }
        
        addSubview(whiteImageView)
        whiteImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        whiteImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(58)
            make.left.right.bottom.equalToSuperview()
        }
        
        settingBtn.rx.tap.bind(onNext: { [weak self] in
            self?.settingBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CentertView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "cen_left_image")
        headView.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
            make.left.equalToSuperview().offset(25)
        }
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "cen_right_image")
        headView.addSubview(twoImageView)
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
            make.right.equalToSuperview().offset(-25)
        }
        oneImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            self?.oneBlock?()
        }).disposed(by: disposeBag)
        
        twoImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            self?.twoBlock?()
        }).disposed(by: disposeBag)
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CentertListViewCell", for: indexPath) as! CentertListViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray?[indexPath.row]
        let pageUrl = model?.trick ?? ""
        self.threeBlock?(pageUrl)
    }
    
}
