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

class LaunchViewController: BaseViewController {
    
    let viewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "launch_app_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        findIDFAInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @MainActor
    deinit {
        print("🚀 deinit - LaunchViewController - deinit")
    }
    
}

extension LaunchViewController {
    
    private func findIDFAInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .restricted:
                        break
                    case .authorized, .notDetermined, .denied:
                        self.oneApiInfo()
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
    
    private func oneApiInfo() {
        Task {
            do {
                async let firstRequest = viewModel.initOneInfo(with: LaunchInitInfo.getJsonInfo())
                async let secondRequest = viewModel.initTwoInfo(with: [
                    "sullen": DeviceIDManager.shared.getIDFV(),
                    "walked": DeviceIDManager.shared.getIDFA()
                ])
                
                let (firstModel, _) = try await (firstRequest, secondRequest)
                

                if firstModel.sentences == "0" {
                    googleModel(with: firstModel.credulity?.efforts ?? effortsModel())
                }
                
                await MainActor.run {
                    NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                }
                
            } catch {
                await MainActor.run {
                    NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                }
            }
        }
    }
    
    private func googleModel(with model: effortsModel) {
        Settings.shared.appURLSchemeSuffix = model.prevail ?? ""
        Settings.shared.appID = model.entreaties ?? ""
        Settings.shared.displayName = model.withdraw ?? ""
        Settings.shared.clientToken = model.withdraw ?? ""
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }
}
