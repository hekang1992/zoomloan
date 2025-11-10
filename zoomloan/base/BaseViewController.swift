//
//  BaseViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import RxSwift

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
