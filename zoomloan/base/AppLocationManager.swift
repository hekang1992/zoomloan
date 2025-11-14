//
//  AppLocationManager.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

import Foundation
import CoreLocation

struct AppLocation {
    let latitude: Double
    let longitude: Double
    let country: String?
    let isoCountryCode: String?
    let province: String?
    let city: String?
    let district: String?
    let street: String?
    let fullAddress: String?
    
    static var empty: AppLocation {
        return AppLocation(
            latitude: 0.0,
            longitude: 0.0,
            country: nil,
            isoCountryCode: nil,
            province: nil,
            city: nil,
            district: nil,
            street: nil,
            fullAddress: nil
        )
    }
    
}

final class AppLocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var completion: ((Result<AppLocation, Error>) -> Void)?
    private var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation(completion: @escaping (Result<AppLocation, Error>) -> Void) {
        self.completion = completion
        
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            self.completion?(.success(AppLocation.empty))
        } else {
            locationManager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            completion?(.success(AppLocation.empty))
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        manager.stopUpdatingLocation()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                self.completion?(.failure(error))
                return
            }
            
            if let place = placemarks?.first {
                let model = AppLocation(
                    latitude: location.coordinate.latitude.rounded6(),
                    longitude: location.coordinate.longitude.rounded6(),
                    country: place.country,
                    isoCountryCode: place.isoCountryCode,
                    province: place.administrativeArea,
                    city: place.locality ?? place.subAdministrativeArea,
                    district: place.subLocality,
                    street: [place.thoroughfare, place.subThoroughfare].compactMap { $0 }.joined(),
                    fullAddress: [
                        place.country,
                        place.administrativeArea,
                        place.locality,
                        place.subLocality,
                        place.thoroughfare,
                        place.subThoroughfare
                    ]
                        .compactMap { $0 }
                        .joined()
                )
                self.completion?(.success(model))
            } else {
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
    }
}


extension Double {
    func rounded6() -> Double {
        return (self * 1_000_000).rounded() / 1_000_000
    }
}
