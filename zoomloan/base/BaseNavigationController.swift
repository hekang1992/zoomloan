//
//  BaseNavigationController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = false
        
        if let gestureRecognizers = view.gestureRecognizers {
            for gesture in gestureRecognizers {
                if let popGesture = gesture as? UIScreenEdgePanGestureRecognizer {
                    view.removeGestureRecognizer(popGesture)
                }
            }
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for (index, viewController) in viewControllers.enumerated() {
            if index > 0 {
                viewController.hidesBottomBarWhenPushed = true
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}
