//
//  otherConfig.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import SnapKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        if hexFormatted.hasPrefix("0X") {
            hexFormatted = String(hexFormatted.dropFirst(2))
        }
        
        var hexValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&hexValue)
        
        self.init(hex: UInt32(hexValue), alpha: alpha)
    }
}


class LaunchInitInfo {
    
    static func getJsonInfo() -> [String: Any] {
        var result: [String: Any] = [:]
        
        let language = Locale.preferredLanguages.first ?? "en"
        result["respective"] = language
        
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] else {
            result["separating"] = 0
            result["frequently"] = 0
            return result
        }
        
        let proxyEnabled = (proxySettings["HTTPEnable"] as? Int == 1) ? 1 : 0
        result["separating"] = proxyEnabled
        
        var vpnEnabled = 0
        if let scoped = proxySettings["__SCOPED__"] as? [String: Any] {
            if scoped.keys.contains(where: { $0.contains("tap") || $0.contains("tun") || $0.contains("ppp") || $0.contains("ipsec") }) {
                vpnEnabled = 1
            }
        }
        result["frequently"] = vpnEnabled
        
        return result
    }
}

final class Loading {
    
    // MARK: - Singleton
    static let shared = Loading()
    private init() {}
    
    // MARK: - Views
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isShowing = false
    
    // MARK: - Public Methods
    
    static func show() {
        DispatchQueue.main.async {
            shared.showInternal()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            shared.hideInternal()
        }
    }
    
    // MARK: - Private Methods
    
    private func showInternal() {
        guard !isShowing else { return }
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        isShowing = true
        
        overlayView.addSubview(containerView)
        containerView.addSubview(indicator)
        window.addSubview(overlayView)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        indicator.startAnimating()
    }
    
    private func hideInternal() {
        guard isShowing else { return }
        isShowing = false
        
        indicator.stopAnimating()
        containerView.removeFromSuperview()
        overlayView.removeFromSuperview()
    }
}
