//
//  ChooseViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChooseViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var baseModel: BaseModel?
    
    var begintime: String = ""
    
    var finishtime: String = ""
    
    let locationManager = AppLocationManager()
    
    let locaitonViewModel = LaunchViewModel()
    
    var locationModel: AppLocation?
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("Recommended ID Type", for: .normal)
        oneBtn.setTitleColor(UIColor.init(hexString: "#58BBB5"), for: .normal)
        oneBtn.setTitleColor(.white, for: .selected)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(900))
        oneBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        oneBtn.setBackgroundImage(UIImage(named: "chao_btn_image"), for: .selected)
        oneBtn.isSelected = true
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("Other Options", for: .normal)
        twoBtn.setTitleColor(UIColor.init(hexString: "#58BBB5"), for: .normal)
        twoBtn.setTitleColor(.white, for: .selected)
        twoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(900))
        twoBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        twoBtn.setBackgroundImage(UIImage(named: "chao_btn_image"), for: .selected)
        twoBtn.isSelected = false
        return twoBtn
    }()
    
    lazy var listImageView: UIImageView = {
        let listImageView = UIImageView()
        listImageView.image = UIImage(named: "tab_im_image")
        listImageView.isUserInteractionEnabled = true
        return listImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(ChooseViewCell.self, forCellReuseIdentifier: "ChooseViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.nameLabel.text = "Choose Identity Document"
        headView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(122)
        }
        
        headView.backBlcok = { [weak self] in
            guard let self = self else { return }
            self.backPageView()
        }
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "chose_list_bg_image")
        view.addSubview(bgImageView)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 347, height: 47))
            make.top.equalTo(headView.snp.bottom).offset(-10)
        }
        
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(1)
            make.height.equalTo(45)
            make.width.equalTo(171)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-1)
            make.height.equalTo(45)
            make.width.equalTo(171)
        }
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            oneBtn.isSelected = true
            twoBtn.isSelected = false
            self.modelArray = baseModel?.credulity?.suggestion ?? []
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            oneBtn.isSelected = false
            twoBtn.isSelected = true
            self.modelArray = baseModel?.credulity?.insensibility ?? []
        }).disposed(by: disposeBag)
        
        view.addSubview(listImageView)
        listImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 418))
        }
        
        listImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        begintime = String(Int(Date().timeIntervalSince1970))
        
//        locationManager.requestLocation { result in
//            switch result {
//            case .success(let success):
//                break
//            case .failure(let failure):
//                break
//            }
//        }
    }
    
//    @MainActor
    deinit {
        print("ChooseViewController==============")
    }
    
}

extension ChooseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = modelArray?[indexPath.row] ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseViewCell", for: indexPath) as! ChooseViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.nameLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = String(Int(Date().timeIntervalSince1970))
        
        locationManager.requestLocation { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let dict = ["countenances": "2",
                                "few": "2",
                                "caught": DeviceIDManager.shared.getIDFV(),
                                "earnestly": DeviceIDManager.shared.getIDFA(),
                                "watchful": success.longitude,
                                "villany": success.latitude,
                                "conceal": self.begintime,
                                "thin": time,
                                "drew": ""] as [String : Any]
                    
                    Task {
                        do {
                            let _ = try await self.locaitonViewModel.insertPageInfo(with: dict)
                        } catch  {
                            
                        }
                    }
                }
                
                break
            case .failure(_):
                break
            }
        }
        
        let title = modelArray?[indexPath.row] ?? ""
        let uploadVc = UploadImageViewController()
        uploadVc.authStr = title
        uploadVc.productID = productID
        self.navigationController?.pushViewController(uploadVc, animated: true)
        
    }
}
