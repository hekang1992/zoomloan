//
//  UploadImageViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit
import MJRefresh
import TYAlertController
import AVFoundation
import Photos
import RxSwift
import RxCocoa
import Kingfisher

class UploadImageViewController: BaseViewController{
    
    var authStr: String = ""
    
    var productID: String = ""
    
    var baseModel: BaseModel?
    
    var source: Int = 1
    
    var isFace: Int = 10
    
    lazy var uploadView: UploadAuthView = {
        let uploadView = UploadAuthView()
        return uploadView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "login_bg_image")
        descImageView.contentMode = .scaleAspectFill
        return descImageView
    }()
    
    var pbegintime: String = ""
    var fbegintime: String = ""
    
    let launchViewModel = LaunchViewModel()
    
    let locationManager = AppLocationManager()
            
    var locationModel: AppLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(descImageView)
        descImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headView)
        headView.bgImageView.isHidden = true
        headView.nameLabel.text = "Identity Verification"
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(122)
        }
        
        headView.backBlcok = { [weak self] in
            guard let self = self else { return }
            self.backPageView()
        }
        
        view.addSubview(uploadView)
        uploadView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(-10)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.uploadView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.peopleDetailInfo()
        })
        
        uploadView.photoBlock = { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            loca()
            let angerModel = baseModel.credulity?.anger
            let photo = angerModel?.possessed ?? 0
            if photo == 0 {
                alertPhotoExampleView()
            }else {
                ToastView.showMessage(with: "认证完成===========")
            }
        }
        
        uploadView.faceBlock = { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            loca()
            let angerModel = baseModel.credulity?.anger
            let belongModel = baseModel.credulity?.belong
            let photo = angerModel?.possessed ?? 0
            let face = belongModel?.possessed ?? 0
            if photo == 0 {
                alertPhotoExampleView()
                return
            }
            if face == 0 {
                alertFaceExampleView()
                return
            }
            ToastView.showMessage(with: "认证完成===========")
        }
        
        uploadView.nextBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            let angerModel = baseModel.credulity?.anger
            let belongModel = baseModel.credulity?.belong
            let photo = angerModel?.possessed ?? 0
            let face = belongModel?.possessed ?? 0
            if photo == 0 {
                alertPhotoExampleView()
                return
            }
            if face == 0 {
                alertFaceExampleView()
                return
            }
            self.backToProductPageVc()
        }).disposed(by: disposeBag)
        
        peopleDetailInfo()
        
        pbegintime = String(Int(Date().timeIntervalSince1970))
        
        loca()
    }
    
    private func loca() {
        locationManager.requestLocation { result in
            switch result {
            case .success(let success):
                self.locationModel = success
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}

extension UploadImageViewController {
    
    private func peopleDetailInfo() {
        let viewModel = ProductDetailViewModel()
        let json = ["suits": productID]
        
        defer {
            self.uploadView.scrollView.mj_header?.endRefreshing()
        }
        
        Task {
            do {
                let model = try await viewModel.facePageInfo(with: json)
                if model.sentences == "0" {
                    self.baseModel = model
                    let angerModel = model.credulity?.anger
                    let belongModel = model.credulity?.belong
                    let photo = angerModel?.possessed ?? 0
                    let face = belongModel?.possessed ?? 0
                    
                    if photo == 0 {
                        alertPhotoExampleView()
                        return
                    }
                    
                    if photo == 1 {
                        let logoUrl = angerModel?.trick ?? ""
                        self.uploadView.oneListView.asoImageView.isHidden = false
                        self.uploadView.oneListView.descImageView.kf.setImage(with: URL(string: logoUrl))
                        self.uploadView.oneListView.loginBtn.isHidden = true
                    }
                    
                    if face == 0 {
                        alertFaceExampleView()
                        return
                    }
                    
                    if face == 1 {
                        let logoUrl = belongModel?.trick ?? ""
                        self.uploadView.twoListView.asoImageView.isHidden = false
                        self.uploadView.twoListView.descImageView.kf.setImage(with: URL(string: logoUrl))
                        self.uploadView.twoListView.loginBtn.isHidden = true
                    }
                }
            } catch {
                
            }
        }
    }
    
    
    private func alertPhotoExampleView() {
        isFace = 11
        let examView = PopExampleView(frame: self.view.bounds)
        examView.bgImageView.image = UIImage(named: "pop_imge_image")
        let alertVc = TYAlertController(alert: examView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        examView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        examView.sureBlock = { [weak self] in
            self?.dismiss(animated: true) {
                self?.showImagePickerSheet()
            }
        }
    }
    
    private func alertFaceExampleView() {
        isFace = 10
        fbegintime = String(Int(Date().timeIntervalSince1970))
        let examView = PopExampleView(frame: self.view.bounds)
        examView.bgImageView.image = UIImage(named: "popface_image")
        let alertVc = TYAlertController(alert: examView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        examView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        examView.sureBlock = { [weak self] in
            self?.dismiss(animated: true) {
                self?.loca()
                self?.checkCameraPermission(with: 1)
            }
        }
    }
    
}

extension UploadImageViewController {
    
    private func showImagePickerSheet() {
        let alertController = UIAlertController(
            title: "选择图片",
            message: "请选择图片来源",
            preferredStyle: .actionSheet
        )
        
        // 相机选项
        let cameraAction = UIAlertAction(title: "拍照", style: .default) { [weak self] _ in
            self?.source = 1
            self?.checkCameraPermission(with: 0)
        }
        
        // 相册选项
        let photoLibraryAction = UIAlertAction(title: "从相册选择", style: .default) { [weak self] _ in
            self?.source = 2
            self?.checkPhotoLibraryPermission()
        }
        
        // 取消选项
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        // 添加操作
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - 权限检查
    private func checkCameraPermission(with source: Int) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // 已授权，打开相机
            openCamera(with: source)
        case .notDetermined:
            // 未决定，请求权限
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.openCamera(with: source)
                    } else {
                        self?.showPermissionAlert(message: "相机权限被拒绝，请在设置中启用")
                    }
                }
            }
        case .denied, .restricted:
            // 被拒绝或受限
            showPermissionAlert(message: "相机权限被拒绝，请在设置中启用")
        @unknown default:
            break
        }
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            // 已授权，打开相册
            openPhotoLibrary()
        case .notDetermined:
            // 未决定，请求权限
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.openPhotoLibrary()
                    } else {
                        self?.showPermissionAlert(message: "相册权限被拒绝，请在设置中启用")
                    }
                }
            }
        case .denied, .restricted:
            // 被拒绝或受限
            showPermissionAlert(message: "相册权限被拒绝，请在设置中启用")
        case .limited:
            // iOS 14+ 有限权限
            openPhotoLibrary()
        @unknown default:
            break
        }
    }
    
    // MARK: - 打开相机和相册
    private func openCamera(with source: Int) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "错误", message: "相机不可用")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = source == 1 ? .front : .rear
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(title: "错误", message: "相册不可用")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    // MARK: - 提示框
    private func showPermissionAlert(message: String) {
        let alert = UIAlertController(
            title: "权限提示",
            message: message,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "确定", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // 获取编辑后的图片或原图
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            // 在这里处理选择的图片
            handleSelectedImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func handleSelectedImage(_ image: UIImage) {
        uploadInagApi(with: image)
    }
    
   
}

extension UploadImageViewController {
    
    private func uploadInagApi(with image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 0.3) ?? Data()
        let viewModel = UploadAuthViewModel()
        let json = ["increasing": source, "odd": isFace, "insulted": authStr] as [String : Any]
        Task {
            do {
                let model = try await viewModel.uploadImageInfo(with: json, imageData: imageData)
                if model.sentences == "0" {
                    if isFace == 11 {
                        alertNameView(with: model.credulity?.scrupulous ?? [])
                    }else {
                        self.peopleDetailInfo()
                        self.fourInfo()
                    }
                }else {
                    ToastView.showMessage(with: model.regarding ?? "")
                }
            } catch  {
                
            }
        }
    }
    
    private func alertNameView(with modelArray: [scrupulousModel]) {
        let viweModel = UploadAuthViewModel()
        let nameView = AlertNameView(frame: self.view.bounds)
        nameView.modelArray = modelArray
        let alertVc = TYAlertController(alert: nameView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        nameView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        nameView.sureBlock = { [weak self] in
            guard let self = self else { return }
            var json = ["insulted": authStr, "odd": isFace]
            modelArray.forEach { model in
                let key = model.sentences ?? ""
                json[key] = model.importance ?? ""
            }
            Task {
                do {
                    let model = try await viweModel.saveMessageInfo(with: json)
                    if model.sentences == "0" {
                        self.dismiss(animated: true) {
                            self.peopleDetailInfo()
                            self.threeInfo()
                        }
                    }else {
                        ToastView.showMessage(with: model.regarding ?? "")
                    }
                } catch  {
                    
                }
            }
        }
    }
    
    private func threeInfo() {
        let dict = ["countenances": "3",
                    "few": "2",
                    "caught": DeviceIDManager.shared.getIDFV(),
                    "earnestly": DeviceIDManager.shared.getIDFA(),
                    "watchful": self.locationModel?.longitude ?? 0.0,
                    "villany": self.locationModel?.latitude ?? 0.0,
                    "conceal": self.pbegintime,
                    "thin": String(Int(Date().timeIntervalSince1970)),
                    "drew": ""] as [String : Any]
        
        Task {
            do {
                let _ = try await self.launchViewModel.insertPageInfo(with: dict)
            } catch  {
                
            }
        }
    }
    
    private func fourInfo() {
        let dict = ["countenances": "4",
                    "few": "2",
                    "caught": DeviceIDManager.shared.getIDFV(),
                    "earnestly": DeviceIDManager.shared.getIDFA(),
                    "watchful": self.locationModel?.longitude ?? 0.0,
                    "villany": self.locationModel?.latitude ?? 0.0,
                    "conceal": self.fbegintime,
                    "thin": String(Int(Date().timeIntervalSince1970)),
                    "drew": ""] as [String : Any]
        
        Task {
            do {
                let _ = try await self.launchViewModel.insertPageInfo(with: dict)
            } catch  {
                
            }
        }
    }
    
}
