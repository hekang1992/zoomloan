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
    static let shared = Loading()
    
    private var loadingView: UIView?
    private var backgroundView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            
            if shared.loadingView != nil { return }
            
            let loadingView = UIView()
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .darkGray
            backgroundView.layer.cornerRadius = 20
            backgroundView.clipsToBounds = true
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            
            loadingView.addSubview(backgroundView)
            loadingView.addSubview(activityIndicator)
            window.addSubview(loadingView)
            
            // 设置约束
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            backgroundView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 80, height: 80))
            }
            
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            shared.loadingView = loadingView
            shared.backgroundView = backgroundView
            shared.activityIndicator = activityIndicator
            
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                loadingView.alpha = 1.0
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            guard let loadingView = shared.loadingView else { return }
            
            UIView.animate(withDuration: 0.2, animations: {
                loadingView.alpha = 0
            }, completion: { _ in
                shared.activityIndicator?.stopAnimating()
                shared.loadingView?.removeFromSuperview()
                
                shared.activityIndicator = nil
                shared.backgroundView = nil
                shared.loadingView = nil
            })
        }
    }
    
    // 可选：自定义样式的方法
    static func setBackgroundColor(_ color: UIColor) {
        shared.backgroundView?.backgroundColor = color
    }
    
    static func setIndicatorColor(_ color: UIColor) {
        shared.activityIndicator?.color = color
    }
    
    static func setBackgroundSize(_ size: CGSize) {
        shared.backgroundView?.snp.updateConstraints { make in
            make.size.equalTo(size)
        }
    }
}

