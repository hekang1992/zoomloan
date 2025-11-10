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
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
    }
    
    private func setupViewControllers() {
        let firstVC = createNavController(
            title: "Home Page",
            image: UIImage(named: "home_nor") ?? UIImage(),
            selectedImage: UIImage(named: "home_sel") ?? UIImage(),
            rootViewController: HomeViewController()
        )
        
        let secondVC = createNavController(
            title: "Loan Order",
            image: UIImage(named: "sec_nor") ?? UIImage(),
            selectedImage: UIImage(named: "sec_sel") ?? UIImage(),
            rootViewController: OrderViewController()
        )
        
        let thirdVC = createNavController(
            title: "Individual",
            image: UIImage(named: "center_nor") ?? UIImage(),
            selectedImage: UIImage(named: "center_sel") ?? UIImage(),
            rootViewController: CenterViewController()
        )
        
        viewControllers = [firstVC, secondVC, thirdVC]
        
        selectedIndex = 0
    }
    
    private func createNavController(title: String, image: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysTemplate),
            selectedImage: selectedImage.withRenderingMode(.alwaysTemplate)
        )
        
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        return navController
    }
}

