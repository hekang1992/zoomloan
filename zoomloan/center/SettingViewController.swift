//
//  SettingViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import SnapKit

class SettingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.nameLabel.text = "Settings"
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(122)
        }
        headView.backBlcok = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "logo_desc_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 114, height: 114))
        }
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 200, height: 17))
        }
        let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        nameLabel.text = "Version number \(versionStr)"
        
        let whiteView = UIView(frame: .zero)
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 16
        whiteView.layer.masksToBounds = true
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(54)
        }
        
        let descLabel = UILabel()
        descLabel.text = "Exit zoom loan"
        descLabel.textAlignment = .left
        descLabel.textColor = UIColor.init(hexString: "#333333")
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "click_icon_right_image")
        
        whiteView.addSubview(descLabel)
        whiteView.addSubview(rightImageView)
        
        descLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        
        let deletelabel = UILabel()
        let attributedString = NSAttributedString(
            string: "Delete zoom loan",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500)),
                .foregroundColor: UIColor.init(hexString: "#999999")
            ]
        )
        deletelabel.attributedText = attributedString
        view.addSubview(deletelabel)
        deletelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.height.equalTo(20)
        }
    }
    
}
