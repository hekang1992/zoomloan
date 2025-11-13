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

final class HomeViewController: BaseViewController {
    
    private lazy var homeView: HomeView = {
        let view = HomeView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    private lazy var lampView: LampView = {
        let view = LampView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        getAssInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHomeMessageInfo()
    }
}

// MARK: - Private Methods

private extension HomeViewController {
    
    func setupUI() {
        [homeView, lampView].forEach { view.addSubview($0) }
        
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        lampView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        homeView.scrollView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getHomeMessageInfo()
        }
    }
    
    func setupBindings() {
        homeView.applyBlock = { [weak self] model in
            self?.applyProductInfo(with: model)
        }
    }
    
    // MARK: - Network
    
    func getHomeMessageInfo() {
        let viewModel = HomeViewModel()
        let params = ["author": "1"]
        
        Task {
            do {
                let model = try await viewModel.getHomeInfo(with: params)
                await MainActor.run {
                    self.handleHomeInfo(model)
                }
            } catch {
                
            }
            
            await MainActor.run {
                self.homeView.scrollView.mj_header?.endRefreshing()
            }
        }
    }
    
    func applyProductInfo(with model: chairsModel) {
        let viewModel = HomeViewModel()
        let params = ["suits": model.borne ?? 0]
        
        Task {
            do {
                let response = try await viewModel.applyProductInfo(with: params)
                await MainActor.run {
                    if response.sentences == "0" {
                        let nextUrl = response.credulity?.trick ?? ""
                        SchemeURLManagerTool.goPageWithPageUrl(nextUrl, from: self)
                    } else {
                        ToastView.showMessage(with: response.regarding ?? "")
                    }
                }
            } catch {
                
            }
        }
    }
    
    func getAssInfo() {
        let viewModel = HomeViewModel()
        
        Task {
            do {
                let model = try await viewModel.getAssInfo(with: ["suits": "1"])
                if model.sentences == "0" {
                    CityConfig.shared.addressModel = model
                }
            } catch {
                
            }
        }
    }
    
    // MARK: - UI Logic
    
    func handleHomeInfo(_ model: BaseModel) {
        guard model.sentences == "0" else {
            ToastView.showMessage(with: model.regarding ?? "")
            return
        }
        
        guard let items = model.credulity?.really, !items.isEmpty else {
            return
        }
        
        if let target = items.first(where: { $0.odd == "she" }) {
            homeView.model = target.chairs?.first
            toggleViews(showHome: true)
        } else {
            toggleViews(showHome: false)
        }
    }
    
    func toggleViews(showHome: Bool) {
        homeView.isHidden = !showHome
        lampView.isHidden = showHome
    }
}
