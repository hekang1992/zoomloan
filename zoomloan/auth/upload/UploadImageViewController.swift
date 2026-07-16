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
            self.backToProductPageVc()
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
                ToastView.showMessage(with: "Complete")
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
            ToastView.showMessage(with: "Complete")
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
            case .failure(_):
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
                        self.uploadView.oneListView.descLabel.text = "Completed"
                        self.uploadView.oneListView.descLabel.textColor = UIColor.init(hexString: "#EA5D50")
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
                        self.uploadView.twoListView.descLabel.text = "Completed"
                        self.uploadView.twoListView.descLabel.textColor = UIColor.init(hexString: "#EA5D50")
                        self.uploadView.twoListView.loginBtn.isHidden = true
                    }
                }
            } catch {
                
            }
        }
    }
    
    
    private func alertPhotoExampleView() {
        isFace = 11
        self.pbegintime = String(Int(Date().timeIntervalSince1970))
        let examView = PopExampleView(frame: self.view.bounds)
        examView.bgImageView.image = UIImage(named: "pop_imge_image")
        let alertVc = TYAlertController(alert: examView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        examView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        examView.sureBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.showImagePickerSheet()
            }
        }
    }
    
    private func alertFaceExampleView() {
        isFace = 10
        let examView = PopExampleView(frame: self.view.bounds)
        examView.bgImageView.image = UIImage(named: "popface_image")
        let alertVc = TYAlertController(alert: examView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        examView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        examView.sureBlock = { [weak self] in
            guard let self = self else { return }
            fbegintime = String(Int(Date().timeIntervalSince1970))
            self.dismiss(animated: true) {
                self.loca()
                self.checkCameraPermission(with: 1)
            }
        }
    }
    
}

extension UploadImageViewController {
    
    private func showImagePickerSheet() {
        let alertController = UIAlertController(
            title: "Choose Image",
            message: "Select Image Source",
            preferredStyle: .actionSheet
        )
        
        // 相机选项
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.source = 1
            self?.checkCameraPermission(with: 0)
        }
        
        // 相册选项
        let photoLibraryAction = UIAlertAction(title: "Album", style: .default) { [weak self] _ in
            self?.source = 2
            self?.checkPhotoLibraryPermission()
        }
        
        // 取消选项
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
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
                        self?.showPermissionAlert(message: "Camera access has been denied. Please enable it in Settings.")
                    }
                }
            }
        case .denied, .restricted:
            // 被拒绝或受限
            showPermissionAlert(message: "Camera access has been denied. Please enable it in Settings.")
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
                        self?.showPermissionAlert(message: "Album access has been denied. Please enable it in Settings.")
                    }
                }
            }
        case .denied, .restricted:
            // 被拒绝或受限
            showPermissionAlert(message: "Album access has been denied. Please enable it in Settings.")
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
            showAlert(title: "Permission", message: "Camera Unavailable")
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
            showAlert(title: "Permission", message: "Album Unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    private func showPermissionAlert(message: String) {
        let alert = UIAlertController(
            title: "Permission",
            message: message,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
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
        
        let okAction = UIAlertAction(title: "Sure", style: .default)
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
        guard let imageData = compressedJPEGData(for: image) else {
            ToastView.showMessage(with: "Image processing failed")
            return
        }

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

    private func compressedJPEGData(for image: UIImage) -> Data? {
        let maximumBytes = 700 * 1024
        let targetBytes = 500 * 1024
        let minimumQuality: CGFloat = 0.1
        let minimumDimension: CGFloat = 320
        let maximumResizeAttempts = 5

        guard let originalData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }

        guard originalData.count > maximumBytes else {
            return originalData
        }

        var workingImage = image

        for _ in 0..<maximumResizeAttempts {
            if let data = jpegData(
                for: workingImage,
                targetBytes: targetBytes,
                maximumBytes: maximumBytes,
                minimumQuality: minimumQuality
            ) {
                return data
            }

            let pixelSize = CGSize(
                width: workingImage.size.width * workingImage.scale,
                height: workingImage.size.height * workingImage.scale
            )
            let shortestSide = min(pixelSize.width, pixelSize.height)

            guard shortestSide > minimumDimension else {
                break
            }

            guard let minimumQualityData = workingImage.jpegData(compressionQuality: minimumQuality) else {
                return nil
            }

            let estimatedScale = sqrt(CGFloat(targetBytes) / CGFloat(minimumQualityData.count)) * 0.9
            let scale = min(max(estimatedScale, 0.5), 0.85)
            let nextSize = CGSize(width: pixelSize.width * scale, height: pixelSize.height * scale)

            workingImage = resizedImage(workingImage, to: nextSize)
        }

        guard let data = workingImage.jpegData(compressionQuality: minimumQuality), data.count <= maximumBytes else {
            return nil
        }

        return data
    }

    private func jpegData(
        for image: UIImage,
        targetBytes: Int,
        maximumBytes: Int,
        minimumQuality: CGFloat
    ) -> Data? {
        guard let minimumQualityData = image.jpegData(compressionQuality: minimumQuality) else {
            return nil
        }

        guard minimumQualityData.count <= maximumBytes else {
            return nil
        }

        var bestData = minimumQualityData
        var lowerQuality = minimumQuality
        var upperQuality: CGFloat = 1.0

        for _ in 0..<6 {
            let quality = (lowerQuality + upperQuality) / 2

            guard let data = image.jpegData(compressionQuality: quality) else {
                return nil
            }

            if data.count > targetBytes {
                upperQuality = quality
            } else {
                bestData = data
                lowerQuality = quality
            }
        }

        return bestData
    }

    private func resizedImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true

        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
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
                            self.threeInfo()
                            self.peopleDetailInfo()
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
        let time = String(Int(Date().timeIntervalSince1970))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let dict = ["countenances": "3",
                        "few": "2",
                        "caught": DeviceIDManager.shared.getIDFV(),
                        "earnestly": DeviceIDManager.shared.getIDFA(),
                        "watchful": UserDefaults.standard.object(forKey: "longitude") ?? "",
                        "villany": UserDefaults.standard.object(forKey: "latitude") ?? "",
                        "conceal": self.pbegintime,
                        "thin": time,
                        "drew": ""] as [String : Any]
            
            Task {
                do {
                    let _ = try await self.launchViewModel.insertPageInfo(with: dict)
                } catch  {
                    
                }
            }
        }
    }
    
    private func fourInfo() {
        let time = String(Int(Date().timeIntervalSince1970))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let dict = ["countenances": "4",
                        "few": "2",
                        "caught": DeviceIDManager.shared.getIDFV(),
                        "earnestly": DeviceIDManager.shared.getIDFA(),
                        "watchful": UserDefaults.standard.object(forKey: "longitude") ?? "",
                        "villany": UserDefaults.standard.object(forKey: "latitude") ?? "",
                        "conceal": self.fbegintime,
                        "thin": time,
                        "drew": ""] as [String : Any]
            
            Task {
                do {
                    let _ = try await self.launchViewModel.insertPageInfo(with: dict)
                } catch  {
                    
                }
            }
        }
    }
    
}
