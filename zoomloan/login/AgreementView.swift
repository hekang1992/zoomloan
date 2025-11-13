//
//  AgreementView.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AgreementView: BaseView {
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "agr_image_nor"), for: .normal)
        button.setImage(UIImage(named: "agr_image_sel"), for: .selected)
        button.tintColor = .systemBlue
        button.isSelected = true
        return button
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    let isAgreed = BehaviorRelay<Bool>(value: true)
    let privacyPolicyTapped = PublishSubject<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        setupAgreementText()
        
        addSubview(stackView)
        stackView.addArrangedSubview(checkButton)
        stackView.addArrangedSubview(agreementLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        agreementLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    private func setupAgreementText() {
        let fullText = "I have read and agree to <Privacy Policy>"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13), range: NSRange(location: 0, length: fullText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "#FFFFFF").withAlphaComponent(0.6), range: NSRange(location: 0, length: fullText.count))
        
        let privacyRange = (fullText as NSString).range(of: "<Privacy Policy>")
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: privacyRange)
        
        agreementLabel.attributedText = attributedString
    }
    
    private func setupBindings() {
        checkButton.rx.tap
            .map { [weak self] in !(self?.checkButton.isSelected ?? false) }
            .bind { [weak self] isSelected in
                self?.checkButton.isSelected = isSelected
                self?.isAgreed.accept(isSelected)
            }
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        agreementLabel.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind { [weak self] gesture in
                let location = gesture.location(in: self?.agreementLabel)
                if self?.isTapOnPrivacyPolicy(location: location) == true {
                    self?.privacyPolicyTapped.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        isAgreed
            .bind(to: checkButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    private func isTapOnPrivacyPolicy(location: CGPoint) -> Bool {
        let fullText = "I have read and agree to Privacy Policy"
        let privacyRange = (fullText as NSString).range(of: "Privacy Policy")
        
        let textStorage = NSTextStorage(attributedString: agreementLabel.attributedText ?? NSAttributedString())
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: agreementLabel.bounds.size)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = agreementLabel.numberOfLines
        textContainer.lineBreakMode = agreementLabel.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let glyphRange = layoutManager.glyphRange(forCharacterRange: privacyRange, actualCharacterRange: nil)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        return boundingRect.contains(location)
    }
}

