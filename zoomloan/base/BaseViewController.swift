//
//  BaseViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import RxSwift
import TYAlertController

class BaseViewController: UIViewController {
    
    lazy var headView: AppMainHeadView = {
        let headView = AppMainHeadView()
        return headView
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hexString: "#D9EEF3")
    }
    

    func backToProductPageVc() {
        guard let navigationController = self.navigationController else { return }
        if let targetVC = navigationController.viewControllers.first(where: { $0 is ProductDetailViewController }) {
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }

}

extension BaseViewController {
    
    func backPageView() {
        let libraryView = LibraryView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: libraryView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        libraryView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        libraryView.sureBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.backToProductPageVc()
            }
        }
    }
    
}
