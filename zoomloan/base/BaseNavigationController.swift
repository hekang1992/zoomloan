//
//  BaseNavigationController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        removeScreenEdgePanGesture()
    }
    
    // MARK: - Navigation Overrides
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        configureViewControllerBeforePush(viewController)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        configureViewControllersBeforeSet(viewControllers)
        super.setViewControllers(viewControllers, animated: animated)
    }
}

// MARK: - Private Methods
private extension BaseNavigationController {
    func setupNavigationBar() {
        navigationBar.isHidden = true
        navigationBar.isTranslucent = false
    }
    
    func removeScreenEdgePanGesture() {
        view.gestureRecognizers?
            .compactMap { $0 as? UIScreenEdgePanGestureRecognizer }
            .forEach { view.removeGestureRecognizer($0) }
    }
    
    func configureViewControllerBeforePush(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = !viewControllers.isEmpty
    }
    
    func configureViewControllersBeforeSet(_ viewControllers: [UIViewController]) {
        viewControllers.enumerated().forEach { index, viewController in
            if index > 0 {
                viewController.hidesBottomBarWhenPushed = true
            }
        }
    }
}
