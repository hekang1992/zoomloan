//
//  AppDeviceManager.swift
//  zoomloan
//
//  Created by hekang on 2025/11/14.
//

import UIKit
import Foundation
import SystemConfiguration
import CoreTelephony

class AppDeviceManager {
    let oneJson = ["hastily": SystemInfo.infoStrings()]
    let twoJson = ["advancing": advancingManager().backJson()]
    let threeJson = ["fear": fearManager().backJson()]
    let fourJson = ["splendour": splendourManager().backJson()]
    let fiveJson = ["terrace": TerraceManager().toJSON()]
    let sixJson = ["consternation": Consternation.toJSON]

    static func toJson() async -> String? {
        let manager = AppDeviceManager()
        var result: [String: Any] = [:]

        manager.oneJson.forEach { result[$0.key] = $0.value }
        manager.twoJson.forEach { result[$0.key] = $0.value }
        manager.threeJson.forEach { result[$0.key] = $0.value }
        manager.fourJson.forEach { result[$0.key] = $0.value }
        manager.fiveJson.forEach { result[$0.key] = $0.value }
        manager.sixJson.forEach { result[$0.key] = $0.value }

        let wifiJson = await gothicManager().backJson()
        result["gothic"] = ["lofty": wifiJson]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted]) else {
                    return nil
                }

        return String(data: jsonData, encoding: .utf8)
    }
}

class advancingManager {
    func backJson() -> [String: Int] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        let isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full ? 1 : 0
        
        return [
            "gate": batteryLevel,
            "approached": isCharging
        ]
    }
    
}

class fearManager {
    
    var momentary: String?
    var perceiving: String?
    var three: String?
    
    init(momentary: String? = nil,
         perceiving: String? = nil,
         three: String? = nil) {
        let current = UIDevice.current
        self.momentary = current.systemVersion
        self.perceiving = current.model
        self.three = deviceModelIdentifier()
    }
    
    func backJson() -> [String: String] {
        return [
            "momentary": momentary ?? "",
            "perceiving": perceiving ?? "",
            "three": three ?? ""
        ]
    }
    
    func deviceModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
}

class splendourManager {
    var darted: String?
    var beams: String?
    
    init(darted: String? = nil,
         beams: String? = nil) {
        let jb = JailbreakDetector.isJailbroken()
        let sim = JailbreakDetector.isSimulator()
        self.darted = String(sim)
        self.beams = String(jb)
    }
    
    func backJson() -> [String: String] {
        return [
            "darted": darted ?? "",
            "beams": beams ?? ""
        ]
    }
}


class gothicManager {
    var shade: String?
    var choler: String?
    
    init(shade: String? = nil,
         choler: String? = nil) {
        self.shade = shade
        self.choler = choler
    }
    
    func backJson() async -> [String: String] {
        do {
            let wifiConfig = try await WiFiConfig.getBSSIDInfo()
            self.shade = wifiConfig.bssid
            self.choler = wifiConfig.ssid
        } catch {
            
        }
        
        return [
            "shade": shade ?? "",
            "choler": choler ?? ""
        ]
    }
}

class Consternation {
    
    private static let installeds: [(name: String, schemes: [String])] = [
        ("young", ["appsFlyer6477775943"]),
        ("disagreement", ["apaylater", "fb178740317610746"]),
        ("effort", ["bingoplus"]),
        ("disguised", ["bpiRuby"]),
        ("ll", ["cashalo"]),
        ("swear", ["Cashola"]),
        ("sword", ["com.lavie.newcoast"]),
        ("draw", ["fidoph"]),
        ("walk", ["fb"]),
        ("business", ["ftlending"]),
        ("comes", ["gcash"]),
        ("gentleman", ["googlegmail"]),
        ("agreeable", ["grab"]),
        ("discoursing", ["hcphapp"]),
        ("ungenteel", ["instagram"]),
        ("excuse", ["juanhand"]),
        ("displeasure", ["seabankph", "maribankph"]),
        ("mistaking", ["paymaya"]),
        ("displeased", ["megapeso"]),
        ("fault", ["mocasa"]),
        ("die", ["okapp"]),
        ("violent", ["pesoloan"]),
        ("dying", ["playtime"]),
        ("trying", ["reddit"]),
        ("hate", ["shopeeph"]),
        ("body", ["skyro"]),
        ("hated", ["snssdk1233"]),
        ("disguise", ["whatsapp"]),
        ("ladies", ["twitter"])
    ]
    
    private static func isAppInstalled(scheme: String) -> Bool {
        guard let url = URL(string: "\(scheme)://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    static var toJSON: [String: String] {
        installeds.reduce(into: [String: String]()) { result, definition in
            result[definition.name] = definition.schemes.contains { isAppInstalled(scheme: $0) } ? "1" : "0"
        }
    }
    
}
