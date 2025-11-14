//
//  PeopleInfoViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import TYAlertController
import RxSwift
import RxCocoa
import MJRefresh

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
    
    var begintime: String = ""
    
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
            guard let self = self else { return }
            self.backPageView()
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
        var json = ["suits": productID]
        nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let modelArray = modelArray else { return }
            modelArray.forEach { model in
                let conscious = model.conscious ?? ""
                let key = model.sentences ?? ""
                if conscious == "times" {
                    json[key] = model.odd ?? ""
                }else {
                    json[key] = model.impunity ?? ""
                }
            }
            addChangeInfo(with: json as! [String : String])
        }).disposed(by: disposeBag)
        
        
        //        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
        //            self?.listInfo()
        //        })
        
        begintime = DEFINE_TIME
        
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
        
        //        defer {
        //            self.tableView.mj_header?.endRefreshing()
        //        }
        
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
    
    private func addChangeInfo(with json: [String: String]) {
        let viewModel = PeopleInfoViewModel()
        Task {
            do {
                let model = try await viewModel.saveInfo(with: json)
                if model.sentences == "0" {
                    
                    await self.insertInfo(with: "5", begin: begintime, finish: DEFINE_TIME, orderID: "")
                    
                    self.backToProductPageVc()
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch {
                
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
            cell.clickBlock = { [weak self] in
                self?.view.endEditing(true)
                self?.clickCell(with: model, cell: cell)
            }
            return cell
        }
        
    }
    
    private func clickCell(with model: superiorityModel?, cell: EnumViewCell) {
        guard let model = model else { return }
        let conscious = model.conscious ?? ""
        if conscious == "times" {
            let listView = PopEnumListView(frame: self.view.bounds)
            listView.nameLabel.text = model.affray ?? ""
            listView.modelArray = model.irascible ?? []
            let alertVc = TYAlertController(alert: listView, preferredStyle: .actionSheet)
            self.present(alertVc!, animated: true)
            listView.cancelBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            listView.sureBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            listView.selecbBlock = { listModel in
                cell.numTextField.text = listModel.choler ?? ""
                model.impunity = listModel.choler ?? ""
                model.odd = listModel.odd ?? ""
            }
        }else {
            let listView = PopAddressView(frame: self.view.bounds)
            listView.nameLabel.text = model.affray ?? ""
            let modelArray = CityConfig.shared.addressModel?.credulity?.really ?? []
            listView.provincesData = modelArray
            let alertVc = TYAlertController(alert: listView, preferredStyle: .actionSheet)
            self.present(alertVc!, animated: true)
            listView.cancelBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            listView.sureBlock = { [weak self] one, two, three in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    cell.numTextField.text = one + "|" + two + "|" + three
                    model.impunity = one + "|" + two + "|" + three
                    model.odd = one + "|" + two + "|" + three
                }
            }
        }
    }
    
}
