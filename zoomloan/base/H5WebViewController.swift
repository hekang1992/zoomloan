//
//  H5WebViewController.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import UIKit
import WebKit
import RxSwift
import StoreKit
import SnapKit
import RxCocoa

private enum Constants {
    static let headViewHeight: CGFloat = 122
    static let progressViewHeight: CGFloat = 2
    static let progressViewTopOffset: CGFloat = -30
    
    enum ScriptMessageNames {
        static let disturbed = "disturbed"
        static let eat = "eat"
        static let bit = "bit"
        static let truly = "truly"
        static let tholouse = "tholouse"
        static let mons = "mons"
        static let merveille = "merveille"
        
        static var all: [String] {
            return [disturbed, eat, bit, truly, tholouse, mons, merveille]
        }
    }
}

// MARK: - Script Handler Delegate Protocol
protocol H5WebViewControllerScriptHandlerDelegate: AnyObject {
    func scriptHandler(_ handler: H5WebViewControllerScriptHandler,
                      didReceiveMessage name: String,
                      body: Any)
    func scriptHandlerRequestNavigationController(_ handler: H5WebViewControllerScriptHandler) -> UINavigationController?
    func scriptHandlerRequestViewController(_ handler: H5WebViewControllerScriptHandler) -> UIViewController?
}

// MARK: - Separate Script Message Handler
class H5WebViewControllerScriptHandler: NSObject, WKScriptMessageHandler {
    
    static let shared = H5WebViewControllerScriptHandler()
    
    weak var delegate: H5WebViewControllerScriptHandlerDelegate?
    
    override init() {
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        print("Received message: \(message.name) - \(message.body)")
        
        delegate?.scriptHandler(self, didReceiveMessage: message.name, body: message.body)
    }
}

class H5WebViewController: BaseViewController {
    
    // MARK: - Public Properties
    var pageUrl: String?
    var orderID: String = ""
    var type: String = ""
    
    // MARK: - Private Properties
    private let webView: WKWebView
    private let progressView = UIProgressView()
    
    var begintime: String = ""
    
    // MARK: - Initialization
    init() {
        let configuration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        super.init(nibName: nil, bundle: nil)
        H5WebViewController.addScriptMessageHandlers(to: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
        loadWebContent()
        
        // 设置脚本处理器代理
        H5WebViewControllerScriptHandler.shared.delegate = self
    }
    
    @MainActor
    deinit {
        removeScriptMessageHandlers()
        H5WebViewControllerScriptHandler.shared.delegate = nil
    }
}

// MARK: - Setup
private extension H5WebViewController {
    
    func setupUI() {
        view.addSubview(headView)
        view.addSubview(progressView)
        view.addSubview(webView)
        
        setupProgressView()
        setupWebView()
        setupHeadView()
    }
    
    func setupProgressView() {
        progressView.progressTintColor = UIColor(hexString: "#333333")
        progressView.trackTintColor = .lightGray
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
    }
    
    func setupHeadView() {
        headView.backBlcok = { [weak self] in
            self?.handleBackAction()
        }
    }
    
    func setupConstraints() {
        headView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Constants.headViewHeight)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(Constants.progressViewTopOffset)
            make.height.equalTo(Constants.progressViewHeight)
        }
        
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom)
        }
    }
    
    func setupBindings() {
        bindTitleUpdates()
        bindProgressUpdates()
    }
    
    func bindTitleUpdates() {
        webView.rx.observe(String.self, "title")
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(to: headView.nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindProgressUpdates() {
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                self?.updateProgressView(with: progress)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Web Content Management
private extension H5WebViewController {
    
    func loadWebContent() {
        guard let url = buildWebURL() else {
            print("Invalid URL")
            return
        }
        
        webView.load(URLRequest(url: url))
        print("Loaded URL: \(url.absoluteString)")
    }
    
    func buildWebURL() -> URL? {
        guard let pageUrl = pageUrl,
              let apiUrl = ParameterToUrlConfig.appendQuery(
                to: pageUrl,
                parameters: ApiCommonParaConfig.loginDictInfo()
              ),
              let encodedUrlString = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            return nil
        }
        return url
    }
}

// MARK: - Script Message Handling
private extension H5WebViewController {
    
    static func addScriptMessageHandlers(to configuration: WKWebViewConfiguration) {
        Constants.ScriptMessageNames.all.forEach { name in
            configuration.userContentController.add(
                H5WebViewControllerScriptHandler.shared,
                name: name
            )
        }
    }
    
    func removeScriptMessageHandlers() {
        Constants.ScriptMessageNames.all.forEach { name in
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

// MARK: - Navigation Handling
private extension H5WebViewController {
    
    func handleBackAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigateBack()
        }
    }
    
    func navigateBack() {
        if type == "1" {
            backToProductPageVc()
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - Progress View Management
private extension H5WebViewController {
    
    func updateProgressView(with progress: Double) {
        let isHidden = progress >= 1.0
        progressView.isHidden = isHidden
        
        if !isHidden {
            progressView.setProgress(Float(progress), animated: true)
        }
    }
}

// MARK: - WKNavigationDelegate
extension H5WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WebView started loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView failed with error: \(error.localizedDescription)")
    }
}

// MARK: - H5WebViewControllerScriptHandlerDelegate
extension H5WebViewController: H5WebViewControllerScriptHandlerDelegate {
    
    func scriptHandler(_ handler: H5WebViewControllerScriptHandler,
                      didReceiveMessage name: String,
                      body: Any) {
        handleScriptMessage(name: name, body: body)
    }
    
    func scriptHandlerRequestNavigationController(_ handler: H5WebViewControllerScriptHandler) -> UINavigationController? {
        return self.navigationController
    }
    
    func scriptHandlerRequestViewController(_ handler: H5WebViewControllerScriptHandler) -> UIViewController? {
        return self
    }
    
    private func handleScriptMessage(name: String, body: Any) {
        switch name {
        case Constants.ScriptMessageNames.disturbed:
            handleDisturbedMessage(body)
        case Constants.ScriptMessageNames.eat:
            handleEatMessage(body)
        case Constants.ScriptMessageNames.bit:
            handleBitMessage(body)
        case Constants.ScriptMessageNames.truly:
            handleTrulyMessage(body)
        case Constants.ScriptMessageNames.tholouse:
            handleTholouseMessage(body)
        case Constants.ScriptMessageNames.mons:
            handleMonsMessage(body)
        case Constants.ScriptMessageNames.merveille:
            handleMerveilleMessage(body)
        default:
            print("Unhandled message: \(name)")
        }
    }
    
    private func handleDisturbedMessage(_ body: Any) {
        print("Handling disturbed message: \(body)")
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    private func handleEatMessage(_ body: Any) {
        print("Handling eat message: \(body)")
        let pageUrls = body as? [String] ?? []
        SchemeURLManagerTool.goPageWithPageUrl(pageUrls.first ?? "", from: self)
    }
    
    private func handleBitMessage(_ body: Any) {
        print("Handling bit message: \(body)")
        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
    }
    
    private func handleTrulyMessage(_ body: Any) {
        print("Handling truly message: \(body)")
        requestAppStoreReview()
    }
    
    private func handleTholouseMessage(_ body: Any) {
        print("Handling tholouse message: \(body)")
        Task {
            await self.insertInfo(with: "10", begin: DEFINE_TIME, finish: DEFINE_TIME, orderID: orderID)
        }
    }
    
    private func handleMonsMessage(_ body: Any) {
        print("Handling mons message: \(body)")
        begintime = DEFINE_TIME
    }
    
    private func handleMerveilleMessage(_ body: Any) {
        print("Handling merveille message: \(body)")
        Task {
            await self.insertInfo(with: "8", begin: begintime, finish: DEFINE_TIME, orderID: "")
        }
    }
}

// MARK: - Store Review
extension H5WebViewController {
    
    func requestAppStoreReview() {
        guard #available(iOS 14.0, *) else { return }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: windowScene)
    }
}
