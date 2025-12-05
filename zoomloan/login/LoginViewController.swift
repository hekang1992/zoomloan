//
//  LoginViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

class LoginViewController: BaseViewController {
    
    var countdownTimer: Timer?
    var remainingSeconds: Int = 60
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()
    
    
    let locationManager = AppLocationManager()
    
    let locationManagerModel = LocationManagerModel()
    
    var begintime: String = ""
    var finishtime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.codeBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let phone = self.loginView.numTextField.text ?? ""
            if phone.isEmpty {
                ToastView.showMessage(with: DESC_PHONE)
                return
            }
            self.codeInfo(with: phone)
        }).disposed(by: disposeBag)
        
        loginView.voiceBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let phone = self.loginView.numTextField.text ?? ""
            if phone.isEmpty {
                ToastView.showMessage(with: DESC_PHONE)
                return
            }
            self.voiceInfo(with: phone)
        }).disposed(by: disposeBag)
        
        loginView.loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let phone = self.loginView.numTextField.text ?? ""
            let code = self.loginView.codeTextFiled.text ?? ""
            let isAgreed = self.loginView.agreementView.isAgreed.value
            if phone.isEmpty {
                ToastView.showMessage(with: DESC_PHONE)
                return
            }
            if code.isEmpty {
                ToastView.showMessage(with: DESC_CODE)
                return
            }
            if !isAgreed{
                ToastView.showMessage(with: DESC_AGREE)
                return
            }
            self.loginView.numTextField.resignFirstResponder()
            self.loginView.codeTextFiled.resignFirstResponder()
            self.loignInfo(with: phone, code: code)
        }).disposed(by: disposeBag)
        
        loginView.agreementView.privacyPolicyTapped.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let model = CredulityConfig.shared.basemodel
            let eage = model?.credulity?.ease ?? ""
            let webVC = H5WebViewController()
            webVC.pageUrl = eage
            self.navigationController?.pushViewController(webVC, animated: true)
        }).disposed(by: disposeBag)
        
        getLocation()
        
        start()
        
    }
    
    @MainActor
    deinit {
        countdownTimer?.invalidate()
    }
    
}

extension LoginViewController {
    
    private func codeInfo(with phone: String) {
        let viewModel = LoginViewModel()
        let json = ["roused": phone]
        Task {
            do {
                let model = try await viewModel.sendCodeInfo(with: json)
                if model.sentences == "0" {
                    self.startTimer()
                    self.loginView.codeBtn.isEnabled = false
                }
                ToastView.showMessage(with: model.regarding ?? "")
            } catch  {
                
            }
        }
    }
    
    private func voiceInfo(with phone: String) {
        let viewModel = LoginViewModel()
        let json = ["roused": phone]
        Task {
            do {
                let model = try await viewModel.sendVoiceCodeInfo(with: json)
                ToastView.showMessage(with: model.regarding ?? "")
            } catch  {
                
            }
        }
    }
    
    private func loignInfo(with phone: String, code: String) {
        let viewModel = LoginViewModel()
        let json = ["equally": phone, "solemn": code]
        Task {
            do {
                let model = try await viewModel.toLoginInfo(with: json)
                if model.sentences == "0" {
                    let token = model.credulity?.considerate ?? ""
                    AuthLoginConfig.shared.saveAuthToken(token)
                    await MainActor.run {
                        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
                    }
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch  {
                
            }
        }
        
        finish()
    }
    
    private func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateCountdown),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func updateCountdown() {
        remainingSeconds -= 1
        updateCountdownDisplay()
        
        if remainingSeconds <= 0 {
            stopCountdown()
        }
    }
    
    func updateCountdownDisplay() {
        print("remainingSeconds======\(remainingSeconds)")
        self.loginView.codeBtn.setTitle("\(remainingSeconds)s", for: .normal)
    }
    
    func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        self.loginView.codeBtn.setTitle("Send", for: .normal)
        self.loginView.codeBtn.isEnabled = true
    }
    
    func start() {
        begintime = String(Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(begintime, forKey: "begintime")
        UserDefaults.standard.synchronize()
    }
    
    func finish() {
        finishtime = String(Int(Date().timeIntervalSince1970))
        UserDefaults.standard.set(finishtime, forKey: "finishtime")
        UserDefaults.standard.synchronize()
    }
    
}

extension LoginViewController {
    
    private func getLocation() {
        locationManager.requestLocation { [weak self] result in
            switch result {
            case .success(let location):
                print("==========================location")
                LocatShange.shared.model = location
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
    
}

class LocatShange {
    static let shared = LocatShange()
    private init() {}
    var model: AppLocation?
}
