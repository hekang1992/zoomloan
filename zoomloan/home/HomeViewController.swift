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
import CoreLocation

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
    
    let locationManager = AppLocationManager()
    
    let launchViewModel = LaunchViewModel()
    
    let locationManagerModel = LocationManagerModel()
    
    var locationModel: AppLocation?
    
    var model: AppLocation?
    
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
    
//    @MainActor
    deinit {
        print("HomeViewController---------deinit======🚗===")
    }
}

// MARK: - Private Methods

private extension HomeViewController {
    
    private func getLocation() {
        locationManager.requestLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.locationModel = location
                let isoCountryCode = location.isoCountryCode ?? ""
                let country = location.country ?? ""
                let json = ["single": location.province ?? "",
                            "written": isoCountryCode,
                            "legibly": location.country ?? "",
                            "horror": location.street ?? "",
                            "villany": location.latitude,
                            "watchful": location.longitude,
                            "dark": location.city ?? "",
                            "haughtiness": location.district ?? ""]
                if !isoCountryCode.isEmpty && !country.isEmpty {
                    self?.pushLocation(with: json)
                    self?.pushDeviceJson()
                }else {
                    self?.pushDeviceJson()
                }
            case .failure(let error):
                print("error=====：\(error.localizedDescription)")
            }
        }
    }
    
    func setupUI() {
        [homeView, lampView].forEach { view.addSubview($0) }
        
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        lampView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        homeView.scrollView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getHomeMessageInfo()
        }
        
        lampView.scrollView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getHomeMessageInfo()
        }
    }
    
    func setupBindings() {
        homeView.applyBlock = { [weak self] model in
            self?.applyProductInfo(with: model)
        }
        
        lampView.headBlock = { [weak self] model in
            self?.applyProductInfo(with: model)
        }
        
        lampView.cellClickBlock = { [weak self] model in
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
                self.lampView.scrollView.mj_header?.endRefreshing()
            }
        }
        
        getLocation()
        pushDec()
    }
    
    func applyProductInfo(with model: chairsModel) {
        
        let alertModel = CredulityConfig.shared.basemodel
        let visibly = alertModel?.credulity?.visibly ?? 0
        
        let locationStatus = CLLocationManager().authorizationStatus
        
        if visibly == 0 {
            realAppluInfo(with: model)
        }else {
            if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
                realAppluInfo(with: model)
            }else {
                if self.showPermissionAlert(message: "Location") {
                    print("have alert =====🏮=====")
                }else {
                    realAppluInfo(with: model)
                }
            }
        }
        
    }
    
    private func realAppluInfo(with model: chairsModel) {
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
        
        let begin = UserDefaults.standard.object(forKey: "begintime") as? String ?? ""
        
        let finish = UserDefaults.standard.object(forKey: "finishtime") as? String ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if !begin.isEmpty && !finish.isEmpty {
                if self.locationModel == nil {
                    self.model = LocatShange.shared.model
                }else {
                    self.model = self.locationModel
                }
                let dict = ["countenances": "1",
                            "few": "2",
                            "caught": DeviceIDManager.shared.getIDFV(),
                            "earnestly": DeviceIDManager.shared.getIDFA(),
                            "watchful": self.model?.longitude ?? 0.0,
                            "villany": self.model?.latitude ?? 0.0,
                            "conceal": begin,
                            "thin": finish,
                            "drew": ""] as [String : Any]
                
                Task {
                    do {
                        let _ = try await self.launchViewModel.insertPageInfo(with: dict)
                    } catch  {
                        
                    }
                    UserDefaults.standard.removeObject(forKey: "begintime")
                    UserDefaults.standard.removeObject(forKey: "finishtime")
                    UserDefaults.standard.synchronize()
                }
                
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
        
        if let target1 = items.first(where: { $0.odd == "she" }) {
            homeView.model = target1.chairs?.first
            toggleViews(showHome: true)
        } else {
            let target2 = items.first(where: { $0.odd == "soon" })
            let target3 = items.first(where: { $0.odd == "and" })
            lampView.model = target2?.chairs?.first
            lampView.modelArray = target3?.chairs ?? []
            toggleViews(showHome: false)
        }
    }
    
    func toggleViews(showHome: Bool) {
        homeView.isHidden = !showHome
        lampView.isHidden = showHome
    }
    
    private func showPermissionAlert(message: String) -> Bool {
        let defaults = UserDefaults.standard
        let key = "PermissionAlertShownDate_\(message)"
        
        if let lastShownDate = defaults.object(forKey: key) as? Date {
            if Calendar.current.isDateInToday(lastShownDate) {
                return false
            }
        }
        
        let alert = UIAlertController(
            title: "权限提示",
            message: message,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        defaults.set(Date(), forKey: key)
        return true
    }
}

extension HomeViewController {
    
    private func pushLocation(with json: [String: Any]) {
        Task {
            do {
                let _ = try await locationManagerModel.toUploadInfo(with: json)
            } catch  {
                
            }
        }
    }
    
    private func pushDeviceJson() {
        let deviceJson = ["credulity": AppDeviceManager.toJson() ?? ""]
        Task {
            do {
                let _ = try await locationManagerModel.toUploadDeviceInfo(with: deviceJson)
            } catch  {
                
            }
        }
    }
    
    private func pushDec() {
        let json = ["sullen": DeviceIDManager.shared.getIDFV(),
                    "walked": DeviceIDManager.shared.getIDFA()]
        Task {
            do {
                let _ = try await launchViewModel.initTwoInfo(with: json)
            } catch  {
                
            }
        }
        
    }
    
}
