//
//  schemeConfig.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

import UIKit
import Foundation

final class SchemeURLManagerTool {
    
    enum SchemePath: String, CaseIterable {
        case setting = "had"
        case home = "all"
        case login = "will"
        case order = "Montoni"
        case productDetail = "that"
        
        var path: String { "/\(rawValue)" }
    }
    
    typealias RouteHandler = (_ url: URL, _ fromVC: BaseViewController, _ params: [String: String]) -> Void
    
    private static var routeHandlers: [String: RouteHandler] = {
        var handlers: [String: RouteHandler] = [:]
        registerDefaultHandlers(into: &handlers)
        return handlers
    }()
    
    
    // MARK: - Register Default
    
    private static func registerDefaultHandlers(into handlers: inout [String: RouteHandler]) {
        handlers[SchemePath.setting.path] = navigateToSettingPage
        handlers[SchemePath.home.path] = navigateToHomePage
        handlers[SchemePath.login.path] = navigateToLoginPage
        handlers[SchemePath.order.path] = navigateToOrderPage
        handlers[SchemePath.productDetail.path] = navigateToProductDetailPage
    }
    
    
    // MARK: - Public
    
    static func goPageWithPageUrl(_ pageUrl: String, from viewController: BaseViewController) {
        guard let url = URL(string: pageUrl) else {
            handleInvalidURL(pageUrl, from: viewController)
            return
        }
        
        if pageUrl.hasPrefix(APISchemConfig.scheme_url) {
            routeToPage(with: url, from: viewController)
        } else {
            openWebPage(with: pageUrl, from: viewController)
        }
    }
    
    
    static func registerRouteHandler(for path: String, handler: @escaping RouteHandler) {
        routeHandlers[path] = handler
    }
    
    static func unregisterRouteHandler(for path: String) {
        routeHandlers.removeValue(forKey: path)
    }
    
    
    // MARK: - Core Route
    
    private static func routeToPage(with url: URL, from viewController: BaseViewController) {
        let path = url.path
        let params = extractParameters(from: url)
        
        guard let handler = routeHandlers[path] else {
            handleUnknownScheme(from: viewController, path: path)
            return
        }
        
        DispatchQueue.main.async {
            handler(url, viewController, params)
        }
    }
    
    
    // MARK: - Default Handlers
    
    @MainActor
    private static func navigateToSettingPage(_ url: URL, fromVC: BaseViewController, params: [String: String]) {
        print("Navigate to Setting Page, params: \(params)")
    }
    
    @MainActor
    private static func navigateToHomePage(_ url: URL, fromVC: BaseViewController, params: [String: String]) {
        print("Navigate to Home Page")
    }
    
    @MainActor
    private static func navigateToLoginPage(_ url: URL, fromVC: BaseViewController, params: [String: String]) {
        print("Navigate to Login Page")
    }
    
    @MainActor
    private static func navigateToOrderPage(_ url: URL, fromVC: BaseViewController, params: [String: String]) {
        print("Navigate to Order Page, params: \(params)")
    }
    
    @MainActor
    private static func navigateToProductDetailPage(_ url: URL, fromVC: BaseViewController, params: [String: String]) {
        guard let productId = params["suits"] else {
            print("❌ Missing productId param (suits)")
            return
        }
        
        let detailVC = ProductDetailViewController()
        detailVC.productID = productId
        fromVC.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private static func extractParameters(from url: URL) -> [String: String] {
        var params: [String: String] = [:]
        let comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        comp?.queryItems?.forEach { params[$0.name] = $0.value ?? "" }
        return params
    }
    
    private static func handleInvalidURL(_ urlString: String, from viewController: BaseViewController) {
        print("❌ Invalid URL: \(urlString)")
    }
    
    private static func handleUnknownScheme(from viewController: BaseViewController, path: String) {
        print("⚠️ Unknown Scheme Path: \(path)")
    }
    
    private static func openWebPage(with urlString: String, from viewController: BaseViewController) {
        let webVC = AppWebViewController()
        webVC.pageUrl = urlString
        viewController.navigationController?.pushViewController(webVC, animated: true)
    }
}


extension SchemeURLManagerTool {
    
    static func canHandleURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        if urlString.hasPrefix(APISchemConfig.scheme_url) {
            return routeHandlers.keys.contains(url.path)
        }
        return true
    }
    
    static var supportedPaths: [String] {
        Array(routeHandlers.keys)
    }
    
    static func generateSchemeURL(for path: SchemePath, parameters: [String: String]? = nil) -> String {
        var urlString = "\(APISchemConfig.scheme_url)\(path.path)"
        
        if let parameters = parameters, !parameters.isEmpty {
            let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            urlString += "?\(queryString)"
        }
        return urlString
    }
}
