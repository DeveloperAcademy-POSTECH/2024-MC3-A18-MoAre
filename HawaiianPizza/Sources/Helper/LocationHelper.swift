//
//  LocationHelper.swift
//  HawaiianPizza
//
//  Created by LeeWanJae on 7/28/24.
//

import Foundation
import MapKit
import CoreLocation

class LocationHelper: NSObject, ObservableObject {
    static let shared = LocationHelper()
    
    var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorization()
    }

    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("위치 권한이 제한되었거나 거부되었습니다.")
        @unknown default:
            break
        }
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        NotificationCenter.default.post(name: .locationUpdate, object: nil, userInfo: ["location": location])
    }
}
