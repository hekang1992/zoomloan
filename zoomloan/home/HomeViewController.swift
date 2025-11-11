//
//  HomeViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import MJRefresh

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
        
        homeView.applyBlock = { [weak self] in
            
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
    
}
