//
//  MainTabBar.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit

class MainTabBar: UITabBarController {

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
    }

    //MARK: - Methods

    func setupVCs() {
        let todayVC = TodayViewController()
        todayVC.tabBarItem = UITabBarItem(title: "Today",
                                          image: UIImage(systemName: Images.sunIcon),
                                          selectedImage: UIImage(systemName: Images.selectedSunIcon))
        let forecastVC = ForecastViewController()
        forecastVC.tabBarItem = UITabBarItem(title: "Forecast",
                                             image: UIImage(systemName: Images.cloudIcon),
                                             selectedImage: UIImage(systemName: Images.selectedCloudIcon))
        viewControllers = [todayVC, forecastVC]
    }

}
