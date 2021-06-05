//
//  NetworkManager.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 5.06.21.
//

import Foundation
import CoreLocation

class NetworkManager {

    // MARK: - Static

    static let shared = NetworkManager()

    // MARK: - Variables

    private let baseUrl: String = "https://api.openweathermap.org/data/2.5/forecast?"
    private let apiKey: String = "6b874494c7d6dcf106922ff8f8605c98"
    private lazy var session = URLSession(configuration: .default)

    // MARK: - Initialization

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
    }

    // MARK: - Methods

    func request<Generic: Decodable>(lat: CLLocationDegrees,
                                     long: CLLocationDegrees,
                                     successHandler: @escaping (Generic) -> Void,
                                     errorHandler: @escaping (NetworkError) -> Void) {

        guard let fullUrl = URL(string: "\(baseUrl)lat=\(lat)&lon=\(long)&units=metric&appid=\(apiKey)") else {
            errorHandler(.incorrectUrl)
            return
        }

        let request = URLRequest(url: fullUrl)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error: Error = error {
                    errorHandler(.networkError(error: error))
                return
            } else if let data: Data = data,
                      let response: HTTPURLResponse = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    do {
                        let model = try JSONDecoder().decode(Generic.self, from: data)
                            successHandler(model)
                    } catch let error {
                            errorHandler(.parsingError(error: error))
                    }
                case 400..<500:
                    break
                case 500...:
                        errorHandler(.serverError(statusCode: response.statusCode))
                default:
                        errorHandler(.unknown)
                }
            }
        }
        dataTask.resume()
    }
}


