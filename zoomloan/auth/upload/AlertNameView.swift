//
//  AlertNameView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlertNameView: BaseView {
    
    var cancelBlock: ExampleBlock?
    var sureBlock: ExampleBlock?
    
    var modelArray: [scrupulousModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "cell_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(InputViewCell.self, forCellReuseIdentifier: "InputViewCell")
        tableView.register(EnumViewCell.self, forCellReuseIdentifier: "EnumViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 317, height: 532))
        }
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oneBtn.snp.top).offset(-25)
            make.size.equalTo(CGSize(width: 311, height: 40))
        }
        
        bgImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.right.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().offset(-130)
        }
        
        oneBtn.rx.tap.bind(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.bind(onNext: { [weak self] in
            self?.sureBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AlertNameView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let sentences = model?.sentences ?? ""
        if sentences == "choler" || sentences == "discovering" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputViewCell", for: indexPath) as! InputViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.model = model
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnumViewCell", for: indexPath) as! EnumViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.model = model
            cell.clickBlock = { [weak self] in
                guard let self = self else { return }
                self.endEditing(true)
                showTimeView(with: cell, model: model ?? scrupulousModel())
            }
            return cell
        }
    }
    
    
}

extension AlertNameView {
    
    private func showTimeView(with cell: EnumViewCell, model: scrupulousModel) {
        let timeView = PopTimeView(frame: self.bounds)
        let time = cell.numTextField.text ?? ""
        let conTime = convertDateString(time) ?? ""
        timeView.defaultDateString = conTime.isEmpty ? "12-12-2000" : conTime
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.addSubview(timeView)
        
        timeView.timeBlock = { time in
            cell.numTextField.text = time
            timeView.defaultDateString = time
            model.importance = time
            timeView.removeFromSuperview()
        }
        timeView.cancelBlock = {
            timeView.removeFromSuperview()
        }
    }
    
    func convertDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }

        return outputFormatter.string(from: date)
    }
    
}
