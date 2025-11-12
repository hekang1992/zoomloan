//
//  ProductDetailViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa

class ProductDetailViewController: BaseViewController {
    
    var productID: String = ""
    
    lazy var listView: ProductDetailView = {
        let listView = ProductDetailView()
        return listView
    }()
    
    var expectedmodel: expectedModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headView)
        headView.bgImageView.isHidden = true
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(122)
        }
        
        headView.backBlcok = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(-20)
        }
        
        self.listView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getProductDetailInfo()
        })
        
        self.listView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            let weak = model.weak ?? ""
            let trick = model.trick ?? ""
            let possessed = model.possessed ?? 0
            if possessed == 1 {
                ChoosePageVcConfig.chooseVc(with: weak, pageUrl: trick, viewController: self)
            }else {
                applyClickInfo(with: self.expectedmodel ?? expectedModel())
            }
        }
        
        self.listView.loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = expectedmodel else { return }
            applyClickInfo(with: model)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getProductDetailInfo()
    }
    
}

extension ProductDetailViewController {
    
    private func applyClickInfo(with model: expectedModel) {
        let weak = model.weak ?? ""
        let trick = model.trick ?? ""
        ChoosePageVcConfig.chooseVc(with: weak, pageUrl: trick, viewController: self)
    }
    
    private func getProductDetailInfo() {
        let viewModel = ProductDetailViewModel()
        let json = ["suits": productID, "zoom": "1"]
        
        defer {
            self.listView.scrollView.mj_header?.endRefreshing()
        }
        
        Task {
            do {
                let model = try await viewModel.detailPageInfo(with: json)
                if model.sentences == "0" {
                    self.headView.nameLabel.text = model.credulity?.head?.profound ?? ""
                    self.listView.loginBtn.setTitle(model.credulity?.head?.illusion ?? "", for: .normal)
                    let repeated = model.credulity?.lowered?.repeated ?? ""
                    self.listView.agreeLabel.isHidden = repeated.isEmpty
                    self.listView.productModel = model.credulity?.head
                    self.listView.modelArray = model.credulity?.produce ?? []
                    self.expectedmodel = model.credulity?.expected
                }
            } catch {
                print(error)
            }
        }
    }
}

class ChoosePageVcConfig {
    
    static func chooseVc(with type: String,
                         pageUrl: String,
                         viewController: ProductDetailViewController) {
        let productID = viewController.productID
        let json = ["suits": productID]
        switch type {
        case "his":
            getFaceInfo(with: json, vc: viewController)
            break
        case "turn":
            let peopleVc = PeopleInfoViewController()
            peopleVc.productID = productID
            viewController.navigationController?.pushViewController(peopleVc, animated: true)
            break
        case "quality":
            let hardVc = LifeHardViewController()
            hardVc.productID = productID
            viewController.navigationController?.pushViewController(hardVc, animated: true)
            break
        case "the":
            let fromVc = FormViewController()
            fromVc.productID = productID
            viewController.navigationController?.pushViewController(fromVc, animated: true)
            break
        case "between":
            break
        case "":
            break
        default:
            break
        }
    }
    
    static private func getFaceInfo(with json: [String: Any],
                                    vc: ProductDetailViewController) {
        let viewModel = ProductDetailViewModel()
        Task {
            do {
                let model = try await viewModel.facePageInfo(with: json)
                if model.sentences == "0" {
                    let angerModel = model.credulity?.anger
                    let photo = angerModel?.possessed ?? 0
                    if photo == 0 {
                        let chooseVc = ChooseViewController()
                        chooseVc.baseModel = model
                        chooseVc.productID = vc.productID
                        chooseVc.modelArray = model.credulity?.suggestion ?? []
                        vc.navigationController?.pushViewController(chooseVc, animated: true)
                    }else {
                        let uploadVc = UploadImageViewController()
                        uploadVc.productID = vc.productID
                        vc.navigationController?.pushViewController(uploadVc, animated: true)
                    }
                }
            } catch {
                
            }
        }
    }
    
}
