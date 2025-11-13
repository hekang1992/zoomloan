//
//  CenterViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import MJRefresh

class CenterViewController: BaseViewController {
    
    lazy var centerView: CentertView = {
        let centerView = CentertView()
        return centerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.centerView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getCenterPageInfo()
        })
        
        self.centerView.settingBlock = { [weak self] in
            let settingVc = SettingViewController()
            self?.navigationController?.pushViewController(settingVc, animated: true)
        }
        
        self.centerView.oneBlock = { [weak self] in
            guard let self = self else { return }
            let model = CredulityConfig.shared.basemodel
            let eage = model?.credulity?.ease ?? ""
            let webVC = H5WebViewController()
            webVC.pageUrl = eage
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        self.centerView.twoBlock = {
            NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil, userInfo: ["order": "1"])
        }
        
        self.centerView.threeBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            SchemeURLManagerTool.goPageWithPageUrl(pageUrl, from: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCenterPageInfo()
    }
    
}

extension CenterViewController {
    
    private func getCenterPageInfo() {
        let viewModel = CentertViewModel()
        let json = ["trick": "1"]
        Task {
            do {
                let model = try await viewModel.toCenterInfo(with: json)
                if model.sentences == "0" {
                    self.centerView.phoneLabel.text = model.credulity?.userInfo?.userphone ?? ""
                    self.centerView.modelArray = model.credulity?.really ?? []
                }
                self.centerView.tableView.reloadData()
                await self.centerView.tableView.mj_header?.endRefreshing()
            } catch {
                await self.centerView.tableView.mj_header?.endRefreshing()
            }
        }
    }
}
