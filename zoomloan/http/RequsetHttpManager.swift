//
//  RequsetHttpManager.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

import UIKit
import Alamofire
import SAMKeychain
import AppTrackingTransparency
import AdSupport

let base_url = "http://47.84.60.25:8600/gnbcyi"

final class RequsetHttpManager {
    static let shared = RequsetHttpManager()
    private init() {}
    
    static var defaultHeaders: HTTPHeaders {
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return header
    }
    
    static var timeout: TimeInterval = 30
    
    static var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return Session(configuration: configuration)
    }()
}

extension RequsetHttpManager {
    
    func get<T: Decodable>(
        _ url: String,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        return try await AF.request(
            getApiUrl(with: url),
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers
        )
        .serializingDecodable(T.self).value
    }
    
    func post<T: Decodable>(
        _ url: String,
        body: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        return try await AF.upload(multipartFormData: { formData in
            body?.forEach { key, value in
                if let data = "\(value)".data(using: .utf8) {
                    formData.append(data, withName: key)
                }
            }
        }, to: getApiUrl(with: url), headers: headers)
        .serializingDecodable(T.self).value
    }
    
    func uploadImage<T: Decodable>(
        _ url: String,
        imageData: Data,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        return try await AF.upload(multipartFormData: { formData in
            
            formData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            
            if let params = params {
                for (key, value) in params {
                    formData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
        }, to: getApiUrl(with: url), headers: headers)
        .serializingDecodable(T.self).value
    }
    
    func getApiUrl(with url: String) -> String {
        let loginJson = ApiCommonParaConfig.loginDictInfo()
        let apiUrl = ParameterToUrlConfig.appendQuery(to: base_url + url, parameters: loginJson)
        return apiUrl ?? ""
    }
    
}


class ApiCommonParaConfig {
    let talking: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    let angry: String = UIDevice.current.name
    let gravely: String = DeviceIDManager.shared.getIDFV()
    let speaking: String = UIDevice.current.systemName
    let considerate: String = AuthLoginConfig.shared.getAuthToken() ?? ""
    let ah: String = DeviceIDManager.shared.getIDFA()
    
    static func loginDictInfo() -> [String: String] {
        let para = ApiCommonParaConfig()
        return ["vallombrosan": para.talking,
                "apozemical": para.angry,
                "thermotensile": para.gravely,
                "fundy": para.speaking,
                "shavery": para.considerate,
                "braunstein": para.ah]
    }
}

/**
 json_decoder
 */
class ParameterToUrlConfig {
    static func appendQuery(to url: String, parameters: [String: String]) -> String? {
        guard var components = URLComponents(string: url) else { return nil }
        
        let newItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = (components.queryItems ?? []) + newItems
        
        return components.url?.absoluteString
    }
}


final class DeviceIDManager {
    
    static let shared = DeviceIDManager()
    private let idfvKey = "stored_idfv"
    private let serviceName = "ll.loan.zoom"
    
    private init() {}
    
    func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func getIDFV() -> String {
        if let savedIDFV = SAMKeychain.password(forService: serviceName, account: idfvKey) {
            return savedIDFV
        }
        let newIDFV = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        saveIDFV(newIDFV)
        return newIDFV
    }
    
    private func saveIDFV(_ idfv: String) {
        let success = SAMKeychain.setPassword(idfv, forService: serviceName, account: idfvKey)
        if !success {
            print("❌ Failed Keychain")
        }
    }
}
