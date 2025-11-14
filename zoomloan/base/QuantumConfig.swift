//
//  QuantumConfig.swift
//  zoomloan
//
//  Created by hekang on 2025/11/14.
//


class QuantumConfig {

    private static var locationManager: AppLocationManager?
    private static var viewModel: LaunchViewModel?

    static func insertPageInfoAsync(with json: [String: String]) async {
        await withCheckedContinuation { continuation in
            Self.insertPageInfo(with: json) {
                continuation.resume()
            }
        }
    }

    private static func insertPageInfo(with json: [String: String],
                                       completion: @escaping () -> Void) {

        self.viewModel = LaunchViewModel()
        self.locationManager = AppLocationManager()

        locationManager?.requestLocation { result in
            switch result {
            case .success(let success):

                var allJson: [String: String] = [
                    "watchful": String(success.longitude),
                    "villany": String(success.latitude),
                    "few": "2",
                    "caught": DeviceIDManager.shared.getIDFV(),
                    "earnestly": DeviceIDManager.shared.getIDFA()
                ]

                allJson = allJson.merging(json) { _, new in new }

                Task {
                    defer {
                        Self.viewModel = nil
                        Self.locationManager = nil
                        completion()
                    }
                    do {
                        _ = try await Self.viewModel?.insertPageInfo(with: allJson)
                    } catch {
                        
                    }
                }

            case .failure(_):
                
                Self.locationManager = nil
                Self.viewModel = nil
                completion()
            }
        }
    }
}
