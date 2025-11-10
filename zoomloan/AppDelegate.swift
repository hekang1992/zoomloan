//
//  AppDelegate.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initNoti()
        initWindow()
        return true
    }
    
    
}

extension AppDelegate {
    
    private func initNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootVc), name: CHANGE_ROOT_VC, object: nil)
    }
    
    private func initWindow() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        window = UIWindow(frame: .zero)
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = LaunchViewController()
        window?.makeKeyAndVisible()
    }
    
    @objc private func changeRootVc() {
        if AuthLoginConfig.shared.isLoggedIn {
            window?.rootViewController = BaseTabBarController()
        }else {
            window?.rootViewController = BaseNavigationController(rootViewController: LoginViewController())
        }
    }
    
}
