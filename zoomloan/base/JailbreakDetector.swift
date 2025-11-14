//
//  JailbreakDetector.swift
//  zoomloan
//
//  Created by hekang on 2025/11/14.
//

import UIKit

struct JailbreakDetector {

    static func isSimulator() -> Int {
        #if targetEnvironment(simulator)
        return 1
        #else
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil {
            return 1
        }
        return 0
        #endif
    }

    static func isJailbroken() -> Int {
        #if targetEnvironment(simulator)
        return 0
        #endif

        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/Applications/RockApp.app"
        ]
        for path in jailbreakFilePaths {
            if FileManager.default.fileExists(atPath: path) {
                return 1
            }
        }

        if let url = URL(string: "cydia://package/com.example.package"),
           UIApplication.shared.canOpenURL(url) {
            return 1
        }

        let testPath = "/private/jb_test.txt"
        do {
            try "jb".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return 1
        } catch {
        }

        if FileManager.default.fileExists(atPath: "/Applications") {
            let tmpFile = "/Applications/jb_test.txt"
            do {
                try "jb".write(toFile: tmpFile, atomically: true, encoding: .utf8)
                try FileManager.default.removeItem(atPath: tmpFile)
                return 1
            } catch {
               
            }
        }

        return 0
    }

    static func statusTuple() -> (jailbroken: Int, simulator: Int) {
        return (isJailbroken(), isSimulator())
    }
}
