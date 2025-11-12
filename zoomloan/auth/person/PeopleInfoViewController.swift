//
//  PeopleInfoViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit

let peo_title = "Personal Details"

class PeopleInfoViewController: BaseViewController {
    
    var productID: String? {
        didSet {
            print("pro=======\(productID ?? "")")
        }
    }
    
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
        tableView.register(InputViewCell.self, forCellReuseIdentifier: "InputViewCell")
        tableView.register(EnumViewCell.self, forCellReuseIdentifier: "EnumViewCell")
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bgView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        nextBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return nextBtn
    }()
    
    var modelArray: [superiorityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.nameLabel.text = peo_title
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(122)
        }
        
        headView.backBlcok = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "lofo_pe_image")
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(headView.snp.bottom).offset(-10)
            make.left.equalToSuperview().offset(18)
        }
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = peo_title
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(700))
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.height.equalTo(15)
        }
        
        view.addSubview(bgView)
        bgView.addSubview(nextBtn)
        
        bgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(83)
        }
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 308, height: 42))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(18)
            make.bottom.equalTo(bgView.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfo()
    }
    
}

extension PeopleInfoViewController {
    
    private func listInfo() {
        let viewModel = PeopleInfoViewModel()
        let json = ["suits": productID ?? ""]
        Task {
            do {
                let model = try await viewModel.getListInfo(with: json)
                if model.sentences == "0" {
                    self.modelArray = model.credulity?.superiority ?? []
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
            
        }
    }
    
}

extension PeopleInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        
        let conscious = model?.conscious ?? ""
        
        if conscious == "you" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputViewCell", for: indexPath) as! InputViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.authModel = model
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnumViewCell", for: indexPath) as! EnumViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.authModel = model
            return cell
        }
        
    }
    
}
