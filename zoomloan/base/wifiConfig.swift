//
//  wifiConfig.swift
//  zoomloan
//
//  Created by hekang on 2025/11/14.
//

import UIKit
import Foundation
import SystemConfiguration
import CoreTelephony
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

class WiFiConfig: NSObject {
    
    enum WiFiError: Error {
        case noInterfaces
        case noNetworkInfo
        case accessDenied
    }
    
    static func getBSSIDInfo() async throws -> (ssid: String?, bssid: String?) {
        
        if #available(iOS 14, *) {
            let status = await NEHotspotNetwork.fetchCurrent()
            switch status {
            case .some(let network):
                return (network.ssid, network.bssid)
            case .none:
                throw WiFiError.noNetworkInfo
            }
        } else {
            // 降级方案：使用旧API
            return try await getBSSIDInfoLegacy()
        }
    }
    
    private static func getBSSIDInfoLegacy() async throws -> (ssid: String?, bssid: String?) {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
                    continuation.resume(throwing: WiFiError.noInterfaces)
                    return
                }
                
                for interface in interfaces {
                    guard let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any] else {
                        continue
                    }
                    
                    let ssid = info[kCNNetworkInfoKeySSID as String] as? String
                    let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String
                    
                    if ssid != nil || bssid != nil {
                        continuation.resume(returning: (ssid, bssid))
                        return
                    }
                }
                
                continuation.resume(throwing: WiFiError.noNetworkInfo)
            }
        }
    }
    
    
}

class TerraceManager {
    
    private(set) var timeZone: String
    private(set) var deviceID: String
    private(set) var language: String
    private(set) var networkType: String
    private(set) var advertisingID: String
    
    init(
        timeZone: String? = nil,
        deviceID: String? = nil,
        language: String? = nil,
        networkType: String? = nil,
        advertisingID: String? = nil
    ) {
        self.timeZone = timeZone ?? TerraceManager.getSystemTimeZone()
        self.deviceID = deviceID ?? TerraceManager.getDeviceID()
        self.language = language ?? TerraceManager.getSystemLanguage()
        self.networkType = networkType ?? TerraceManager.getNetworkType()
        self.advertisingID = advertisingID ?? TerraceManager.getAdvertisingID()
    }
    
    func toJSON() -> [String: String] {
        return [
            "tower": timeZone,
            "sullen": deviceID,
            "respective": language,
            "arch": networkType,
            "walked": advertisingID
        ]
    }
    
    
    private static func getSystemTimeZone() -> String {
        return TimeZone.current.abbreviation() ?? "GMT+9"
    }
    
    private static func getDeviceID() -> String {
        return DeviceIDManager.shared.getIDFV()
    }
    
    private static func getSystemLanguage() -> String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    private static func getAdvertisingID() -> String {
        return DeviceIDManager.shared.getIDFA()
    }
    
    private static func getNetworkType() -> String {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return "OTHER"
        }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reachability, &flags) else {
            return "OTHER"
        }
        
        if flags.contains(.isWWAN) {
            let networkInfo = CTTelephonyNetworkInfo()
            if let currentRadio = networkInfo.serviceCurrentRadioAccessTechnology?.values.first {
                switch currentRadio {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA,
                    CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA,
                    CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
                    return "3G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    if #available(iOS 14.1, *) {
                        if currentRadio == CTRadioAccessTechnologyNRNSA || currentRadio == CTRadioAccessTechnologyNR {
                            return "5G"
                        }
                    }
                    return "5G"
                }
            }
            return "OTHER"
        } else if flags.contains(.reachable) {
            return "WIFI"
        } else {
            return "OTHER"
        }
    }
}
