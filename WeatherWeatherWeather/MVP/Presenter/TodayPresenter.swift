//
//  TodayPresenter.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import Foundation
import CoreLocation

protocol TodayViewPresenter {
    init(view: TodayView)
}

class TodayPresenter: NSObject, TodayViewPresenter {

    //MARK: Properties

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation? // тут нуно observer который будет уведомлять view

    //MARK: Initialization

    required init(view: TodayView) {
        super.init()
        startLocationTracking()
    }

    //MARK: Methods

    func startLocationTracking() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
}

//MARK: CLLocationManagerDelegate

extension TodayPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            //print("coordinates \(currentLocation?.coordinate.latitude) and \(currentLocation?.coordinate.longitude )")
        }
    }
}


