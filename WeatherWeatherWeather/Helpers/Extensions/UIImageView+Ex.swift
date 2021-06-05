//
//  UIImageView+Ex.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//


import UIKit

extension UIImage {
    static func donwload(_ url: String) -> UIImage? {
        guard let fullURL = URL(string: "https://openweathermap.org/img/wn/\(url).png") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fullURL)
            guard let image = UIImage(data: data) else {
                return nil
            }
            return image.withTintColor(.systemYellow)
        } catch {
            return nil
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

