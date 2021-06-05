//
//  ForecastPresenter.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import Foundation
import CoreLocation

protocol ForecastViewPresenter {
    init(view: ForecastView)
    func calculateHeader(forSection section: Int) -> String
    func countSections() -> Int
    func configureModelForTable()
    func calculateNumberOfRows(forSection section: Int) -> Int
    func getModelIn(section: Int, row: Int) -> TableModel
    var arrayForTable: [TableModel] { get }
    func getPlaceName() -> String
}

class ForecastPresenter: NSObject, ForecastViewPresenter {

    //MARK: Properties

    var view: ForecastView!
    var arrayForTable = [TableModel]()
    var sortedArray = [[TableModel]]()

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var networkManager = NetworkManager()

    //MARK: Initialization

    required init(view: ForecastView) {
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

                                DispatchQueue.main.async { [weak self] in
                                    fetchedModel = model
                                    self?.configureModelForTable()
                                }
                               },
                               errorHandler: { (error: NetworkError) in
                                fatalError(error.localizedDescription)
                               })
    }

    func configureModelForTable() {

        guard let model = fetchedModel else { return }

        sortedArray.removeAll()

        for element in 0...39 {
            arrayForTable.append(TableModel(image: "\(model.list[element].weather[0].icon)",
                                            time: model.list[element].dtTxt,
                                            description: "\(model.list[element].weather[0].weatherDescription)",
                                            temperature: "\(model.list[element].main.temp)",
                                            city: "\(model.city.name)"))
        }

        var tempDay = String.convertToDay(date: arrayForTable[0].time)

        sortedArray.append([])

        for day in arrayForTable {

            if String.convertToDay(date: day.time) == tempDay {
                let lastIndex = sortedArray.count-1
                sortedArray[lastIndex].append(day)
            } else {
                tempDay = String.convertToDay(date: day.time)
                sortedArray.append([day])
            }
        }
        view.updateTableView()
    }

    func getPlaceName() -> String {
        guard fetchedModel != nil else { return "" }
        return "\(fetchedModel!.city.name), \(fetchedModel!.city.country)"
    }

    func calculateHeader(forSection section: Int) -> String {
        guard !sortedArray.isEmpty else { return "" }
        return section == 0 ? "Today" : String.convertToDay(date:sortedArray[section][0].time)
    }

    func countSections() -> Int {
        guard !sortedArray.isEmpty else { return 0 }
        return sortedArray.count
    }

    func calculateNumberOfRows(forSection section: Int) -> Int {
        guard !sortedArray.isEmpty else { return 0 }
        return sortedArray[section].count
    }

    func getModelIn(section: Int, row: Int) -> TableModel {
        return sortedArray[section][row]
    }
}

//MARK: CLLocationManagerDelegate

extension ForecastPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            requestTheWeather()
        }
    }
}
