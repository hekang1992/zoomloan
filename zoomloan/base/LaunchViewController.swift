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
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                self?.networkMonitor.stopListening()
                self?.startAppInitialization()
                
            case .notReachable, .unknown:
                break
            }
        }
        networkMonitor.startListening()
    }
}

// MARK: - App Initialization Flow
private extension LaunchViewController {
    
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
            // 受限制的情况，可以选择继续初始化或特殊处理
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
