//
//  LaunchViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import FBSDKCoreKit
import AppTrackingTransparency
import Alamofire

class LaunchViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel = LaunchViewModel()
    private var networkMonitor = NetworkMonitor.shared
    
    // MARK: - UI Components
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "launch_app_image")
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworkMonitoring()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @MainActor
    deinit {
        networkMonitor.stopListening()
        print("🚀 deinit - LaunchViewController - deinit")
    }
}

// MARK: - Setup Methods
private extension LaunchViewController {
    
    func setupUI() {
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNetworkMonitoring() {
        networkMonitor.statusChanged = { [weak self] status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                self?.dynamicDomain()
                
            case .reachable(.cellular):
                self?.dynamicDomain()
                
            case .notReachable, .unknown:
                break
            }
        }
        networkMonitor.startListening()
    }
    
    private func setInitInfo() {
        self.networkMonitor.stopListening()
        self.startAppInitialization()
    }
}

// MARK: - App Initialization Flow
private extension LaunchViewController {
    
    private func dynamicDomain() {
        networkMonitor.stopListening()
        
        let configURL = "https://ph4-dc.oss-ap-southeast-1.aliyuncs.com/zoom-loan/ucxnco.json"
        AF.request(configURL, requestModifier: { request in
            request.timeoutInterval = 10
        }).responseDecodable(of: [[String: String]].self) { [weak self] response in
            guard let self = self else { return }
            
            guard let list = response.value else {
                self.setInitInfo()
                return
            }
            
            let domains = list.compactMap { item in
                item["ap"]?.trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter { !$0.isEmpty }
            
            self.checkDynamicDomain(domains, index: 0)
        }
    }
    
    private func checkDynamicDomain(_ domains: [String], index: Int) {
        guard index < domains.count else {
            setInitInfo()
            return
        }
        
        let domain = domains[index]
        AF.request(domain, requestModifier: { request in
            request.timeoutInterval = 10
        }).response { [weak self] response in
            guard let self = self else { return }
            
            if response.response != nil {
                UserDefaults.standard.set(self.removeTrailingSlash(domain), forKey: "base_url")
                self.setInitInfo()
            } else {
                self.checkDynamicDomain(domains, index: index + 1)
            }
        }
    }
    
    private func removeTrailingSlash(_ url: String) -> String {
        var result = url
        while result.hasSuffix("/") {
            result.removeLast()
        }
        return result
    }
    
    func startAppInitialization() {
        requestTrackingAuthorization()
    }
    
    func requestTrackingAuthorization() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                    self?.handleTrackingAuthorization(status)
                }
            } else {
                self.initializeAppData()
            }
        }
    }
    
    func handleTrackingAuthorization(_ status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized, .denied, .notDetermined:
            initializeAppData()
            
        case .restricted:
            initializeAppData()
            
        @unknown default:
            initializeAppData()
        }
    }
    
    func initializeAppData() {
        Task {
            await fetchInitialData()
        }
    }
    
    @MainActor
    func fetchInitialData() async {
        do {
            async let firstRequest = viewModel.initOneInfo(with: LaunchInitInfo.getJsonInfo())
            async let secondRequest = viewModel.initTwoInfo(with: [
                "sullen": DeviceIDManager.shared.getIDFV(),
                "walked": DeviceIDManager.shared.getIDFA()
            ])
            
            let (firstModel, _) = try await (firstRequest, secondRequest)
            
            if firstModel.sentences == "0" {
                CredulityConfig.shared.basemodel = firstModel
                configureGoogleServices(with: firstModel.credulity?.efforts ?? effortsModel())
            }
            
            navigateToMainScreen()
            
        } catch {
            print("Initial data fetch failed: \(error)")
            navigateToMainScreen()
        }
    }
    
    func configureGoogleServices(with model: effortsModel) {
        Settings.shared.appURLSchemeSuffix = model.prevail ?? ""
        Settings.shared.appID = model.entreaties ?? ""
        Settings.shared.displayName = model.withdraw ?? ""
        Settings.shared.clientToken = model.withdraw ?? ""
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
    
    func navigateToMainScreen() {
        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
    }
}

class CredulityConfig {
    static let shared = CredulityConfig()
    private init() {}
    var basemodel: BaseModel?
}
