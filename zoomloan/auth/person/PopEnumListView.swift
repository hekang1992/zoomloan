//
//  PopEnumListView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopEnumListView: BaseView {
    
    var modelArray: [irascibleModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// select_model_enum
    var selecbBlock: ((irascibleModel) -> Void)?
    
    var selectindexPath: IndexPath?
    
    var cancelBlock: ExampleBlock?
    
    var sureBlock: ExampleBlock?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "time_sco_image")
        descImageView.isUserInteractionEnabled = true
        return descImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "Select a date"
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return nameLabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "canel_seldata_image"), for: .normal)
        return cancelBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Confirm", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PopEnumListCell.self, forCellReuseIdentifier: "PopEnumListCell")
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImageView)
        bgImageView.addSubview(descImageView)
        bgImageView.addSubview(loginBtn)
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(411)
        }
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 262))
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 314, height: 48))
            make.centerX.equalToSuperview()
        }
        bgImageView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(22)
        }
        bgImageView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        descImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.sureBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopEnumListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopEnumListCell", for: indexPath) as! PopEnumListCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.model = model
        if let selectindexPath = selectindexPath, selectindexPath == indexPath {
            cell.bgImageView.image = UIImage(named: "pla_suc_fock_image")
        } else {
            cell.bgImageView.image = UIImage(named: "nor_lis_image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectindexPath = indexPath
        tableView.reloadData()
        if let model = modelArray?[indexPath.row] {
            self.selecbBlock?(model)
        }
    }
    
}
