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
    func getBigImage() -> String
    func getPlaceText() -> String
    func getTempText() -> String
    func getLittleLabels() -> [String]
    func getShareInformation() -> String?
}

final class TodayPresenter: NSObject, TodayViewPresenter {

    //MARK: Properties

    var view: TodayView!
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var networkManager = NetworkManager()

    //MARK: Initialization

    required init(view: TodayView) {
        super.init()
        self.view = view
        startLocationTracking()
    }

    //MARK: Methods

    private func startLocationTracking() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    private func requestTheWeather() {

        view.startSpinner()

        guard let lat = currentLocation?.coordinate.latitude,
              let long = currentLocation?.coordinate.longitude else { return }

        networkManager.request(lat: lat, long: long,
                               successHandler: { [weak self] (model: Response) in

                                guard let self = self else { return }

                                //MARK: !!! There is a special delay to show that the UI is not blocked
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                                    fetchedModel = model
                                    self?.view.updateUI()
                                    self?.view.stopSpinner()
                                }
                               },
                               errorHandler: { (error: NetworkError) in
                                fatalError(error.localizedDescription)
                               })
    }

    //MARK: configure methods

    func getBigImage() -> String {
        guard let model = fetchedModel else { return ""}
        return model.list[0].weather[0].icon
    }

    func getPlaceText() -> String {
        guard let model = fetchedModel else { return ""}
        return "\(model.city.name), \(model.city.country)"
    }

    func getTempText() -> String {
        guard let model = fetchedModel else { return ""}
        return "\(model.list[0].main.temp)°С | \(model.list[0].weather[0].weatherDescription)"
    }

    func getLittleLabels() -> [String] {
        guard let model = fetchedModel else { return []}
        return ["\(model.list[0].main.humidity) %","\(model.list[0].rain?.the3H ?? 0) mm",
                "\(model.list[0].main.pressure) hPa", "\(model.list[0].wind.speed) km/h",
                "\(model.list[0].wind.deg) °"]
    }

    func getShareInformation() -> String? {
        if let model = fetchedModel {
            return """
        You are situated in \(model.city.name), \(model.city.country)
        Today is \(String.convertToDay(date: model.list[0].dtTxt)).
        Mostly \(model.list[0].weather[0].main) and the temperature is \(model.list[0].main.temp) degrees.
        Wind speed is \(model.list[0].wind.speed) km/h. Wind angle is \(model.list[0].wind.deg) °.
        Humidity \(model.list[0].main.humidity) % and pressure is \(model.list[0].main.pressure) hPa.
        """
        } else { return nil }
    }
}

//MARK: CLLocationManagerDelegate

extension TodayPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            requestTheWeather()
        }
    }
}


