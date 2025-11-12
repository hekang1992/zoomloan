//
//  PopAddressView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopAddressView: BaseView {
    
    var provincesData: [reallyModel] = []
    private var selectedProvinceIndex = 0
    private var selectedCityIndex = 0
    private var selectedDistrictIndex = 0
    
    var cancelBlock: (() -> Void)?
    var sureBlock: ((String, String, String) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "time_sco_image")
        descImageView.isUserInteractionEnabled = true
        return descImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "选择省市区"
        nameLabel.textColor = UIColor(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nameLabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "canel_seldata_image"), for: .normal)
        return cancelBtn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return btn
    }()
    
    lazy var addressPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PopAddressView {
    func setupUI() {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(411)
        }
        
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(descImageView)
        bgImageView.addSubview(confirmBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(22)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        descImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 262))
        }
        
        descImageView.addSubview(addressPicker)
        addressPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 314, height: 48))
        }
    }
}

private extension PopAddressView {
    func setupActions() {
        cancelBtn.rx.tap.bind { [weak self] in
            self?.cancelBlock?()
        }.disposed(by: disposeBag)
        
        confirmBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let province = self.provincesData[self.selectedProvinceIndex].choler ?? ""
            let city = self.provincesData[self.selectedProvinceIndex].really?[self.selectedCityIndex].choler ?? ""
            let district = self.provincesData[self.selectedProvinceIndex].really?[self.selectedCityIndex].really?[self.selectedDistrictIndex].choler ?? ""
            self.sureBlock?(province, city, district)
        }.disposed(by: disposeBag)
    }
}

// MARK: - UIPickerView Delegate / DataSource
extension PopAddressView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provincesData.count
        case 1:
            return provincesData[selectedProvinceIndex].really?.count ?? 0
        case 2:
            return provincesData[selectedProvinceIndex].really?[selectedCityIndex].really?.count ?? 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return provincesData[row].choler
        case 1:
            return provincesData[selectedProvinceIndex].really?[row].choler
        case 2:
            return provincesData[selectedProvinceIndex].really?[selectedCityIndex].really?[row].choler
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedProvinceIndex = row
            selectedCityIndex = 0
            selectedDistrictIndex = 0
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            selectedCityIndex = row
            selectedDistrictIndex = 0
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            selectedDistrictIndex = row
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        label.textColor = .label
        switch component {
        case 0:
            label.text = provincesData[row].choler
        case 1:
            label.text =  provincesData[selectedProvinceIndex].really?[row].choler
        case 2:
            label.text =  provincesData[selectedProvinceIndex].really?[selectedCityIndex].really?[row].choler
        default:
            break
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}


