//
//  CustomTop.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit
import SnapKit

class CustomTop: UIView {

    //MARK: GUI variables

    private let bigImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Images.sun)
        view.tintColor = .systemYellow
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "It is check"
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "It is check"
        return label
    }()

    private let online: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Images.online)
        return view
    }()

    //MARK: Initialization

    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods

    private func configureUI() {
        addSubviews([bigImage, placeLabel, temperatureLabel, online])


        bigImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.width.equalTo(bigImage.snp.height)
            make.bottom.equalTo(placeLabel.snp.top).offset(-10)
        }

        placeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(bigImage.snp.height).multipliedBy(0.1)
            make.bottom.equalTo(temperatureLabel.snp.top).offset(-10)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(bigImage.snp.height).multipliedBy(0.2)
            make.bottom.equalToSuperview().offset(-10)
        }

        online.snp.makeConstraints { make in
            make.centerY.equalTo(placeLabel)
            make.width.height.equalTo(10)
            make.right.equalTo(placeLabel.snp.left).offset(-10)

        }
    }

    //MARK: Configure method
    
    func setValuesFor(image: String, placeText: String, temperatureText: String) {
        self.bigImage.image = UIImage.donwload(image)
        self.placeLabel.text = placeText
        self.temperatureLabel.text = temperatureText
    }
}
