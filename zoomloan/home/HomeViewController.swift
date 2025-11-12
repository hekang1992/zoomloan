//
//  HomeViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import MJRefresh
import TYAlertController

class HomeViewController: BaseViewController {
    
    lazy var homeView: HomeView = {
        let homeView = HomeView(frame: .zero)
        return homeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.homeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getHomeMessageInfo()
        })
        
        homeView.applyBlock = { [weak self] model in
            guard let self = self else { return }
//            self.applyProductInfo(with: model)
            let timeView = PopTimeView(frame: self.view.bounds)
            timeView.defaultDateString = "12-12-2000"
            let alertVc = TYAlertController(alert: timeView, preferredStyle: .actionSheet)
            self.present(alertVc!, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHomeMessageInfo()
    }
}

extension HomeViewController {
    
    private func getHomeMessageInfo() {
        let viewModel = HomeViewModel()
        let json = ["author": "1"]
        
        Task {
            
            defer {
                Task { @MainActor in
                    self.homeView.scrollView.mj_header?.endRefreshing()
                }
            }
            
            do {
                let model = try await viewModel.getHomeInfo(with: json)
                if model.sentences == "0" {
                    let modelArray = getSheChairs(from: model)
                    self.homeView.model = modelArray.first
                }
            } catch  {
                
            }
        }
    }
    
    func getSheChairs(from model: BaseModel) -> [chairsModel] {
        let modelArray = model.credulity?.really ?? []
        for reallyItem in modelArray {
            if reallyItem.odd == "she" {
                return reallyItem.chairs ?? []
            }
        }
        return []
    }
    
    private func applyProductInfo(with model: chairsModel) {
        let viewModel = HomeViewModel()
        let borne = model.borne ?? 0
        Task {
            do {
                let model = try await viewModel.applyProductInfo(with: ["suits": borne])
                if model.sentences == "0" {
                    let nextPageStr = model.credulity?.trick ?? ""
                    SchemeURLManagerTool.goPageWithPageUrl(nextPageStr, from: self)
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch {
                
            }
        }
    }
    
}

