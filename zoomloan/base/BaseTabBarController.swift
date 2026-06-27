//
//  BaseTabBarController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        self.delegate = self
    }
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(500))
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.5),
            .font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(500))
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        let bgView = UIView(frame: tabBar.bounds)
        bgView.backgroundColor = UIColor(hexString: "#58BBB6")
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(bgView, at: 0)
        
    }
    
    private func setupViewControllers() {
        let firstVC = createNavController(
            title: "Home",
            image: UIImage(named: "home_nor") ?? UIImage(),
            selectedImage: UIImage(named: "home_sel") ?? UIImage(),
            rootViewController: HomeViewController()
        )
        
        let secondVC = createNavController(
            title: "Bills",
            image: UIImage(named: "sec_nor") ?? UIImage(),
            selectedImage: UIImage(named: "sec_sel") ?? UIImage(),
            rootViewController: OrderViewController()
        )
        
        let thirdVC = createNavController(
            title: "Me",
            image: UIImage(named: "center_nor") ?? UIImage(),
            selectedImage: UIImage(named: "center_sel") ?? UIImage(),
            rootViewController: CenterViewController()
        )
        
        viewControllers = [firstVC, secondVC, thirdVC]
        
        selectedIndex = 0
    }
    
    private func createNavController(title: String, image: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> BaseNavigationController {
        let navController = BaseNavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        return navController
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if AuthLoginConfig.shared.isLoggedIn {
            return true
        }else {
            let navVc = BaseNavigationController(rootViewController: LoginViewController())
            navVc.modalPresentationStyle = .overFullScreen
            self.present(navVc, animated: true)
            return false
        }
    }
    
}

