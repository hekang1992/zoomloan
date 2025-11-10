//
//  Untitled.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import Foundation
import UIKit
import Toast_Swift

let CHANGE_ROOT_VC = NSNotification.Name("CHANGE_ROOT_VC")

class AuthLoginConfig {
    static let shared = AuthLoginConfig()
    
    private let tokenKey = "userAuthToken"
    private let userDefaults = UserDefaults.standard
    
    func saveAuthToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
        userDefaults.synchronize()
    }
    
    func getAuthToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    var isLoggedIn: Bool {
        return getAuthToken() != nil
    }
    
    func logout() {
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.synchronize()
    }
}

class ToastView {
    static func showMessage(with message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(message, duration: 3.0, position: .center)
    }
}
