//
//  PopTimeView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopTimeView: BaseView {
    
    var time: String = ""
    
    // MARK: - Public property
    var defaultDateString: String = "12-12-2000" {
        didSet {
            updateDateFromString(defaultDateString)
        }
    }
    
    var timeBlock: ((String) -> Void)?
    
    var cancelBlock: (() -> Void)?
    
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
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.locale = Locale(identifier: "en_GB")
        dp.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return dp
    }()
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        return f
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Confirm", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(700))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        return loginBtn
    }()
    
    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.text = "Day"
        dayLabel.textColor = UIColor.init(hexString: "#333333")
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return dayLabel
    }()
    
    lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.textAlignment = .left
        monthLabel.text = "Month"
        monthLabel.textColor = UIColor.init(hexString: "#333333")
        monthLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return monthLabel
    }()
    
    lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.textAlignment = .left
        yearLabel.text = "Year"
        yearLabel.textColor = UIColor.init(hexString: "#333333")
        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return yearLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "Select a date"
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return nameLabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "canel_seldata_image"), for: .normal)
        return cancelBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateDateFromString(defaultDateString)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateDateFromString(defaultDateString)
    }
    
    // MARK: - UI
    private func setupUI() {
        
        addSubview(bgImageView)
        bgImageView.addSubview(descImageView)
        descImageView.addSubview(dayLabel)
        descImageView.addSubview(monthLabel)
        descImageView.addSubview(yearLabel)
        descImageView.addSubview(datePicker)
        bgImageView.addSubview(loginBtn)
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(397)
        }
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343, height: 262))
        }
        datePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.bottom.equalToSuperview()
        }
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.top)
            make.left.equalTo(dayLabel.snp.right)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.top)
            make.left.equalTo(monthLabel.snp.right).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(13)
            make.size.equalTo(CGSize(width: 314, height: 48))
            make.centerX.equalToSuperview()
        }
        bgImageView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(22)
        }
        bgImageView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            if time.isEmpty {
                self.timeBlock?(defaultDateString)
            }else {
                self.timeBlock?(time)
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateDateFromString(_ str: String) {
        if let date = dateFormatter.date(from: str) {
            datePicker.setDate(date, animated: false)
            let _ = dateFormatter.string(from: date)
        } else {
            if let defaultDate = dateFormatter.date(from: "12-12-2000") {
                datePicker.setDate(defaultDate, animated: false)
                let _ = dateFormatter.string(from: defaultDate)
            }
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let time = dateFormatter.string(from: sender.date)
        self.time = time
        self.timeBlock?(time)
    }
    
    func getSelectedDateString() -> String {
        return dateFormatter.string(from: datePicker.date)
    }
}
