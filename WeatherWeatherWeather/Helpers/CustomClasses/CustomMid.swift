//
//  CustomMid.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit
import SnapKit

class CustomMid: UIView {

    //MARK: GUI variables

    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()

    private let firstHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()

    private let secondHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()

    private let rain = LittleView(empty: false)
    private let humidity = LittleView(empty: false)
    private let temperature = LittleView(empty: false)
    private let wind = LittleView(empty: false)
    private let direction = LittleView(empty: false)

    private let first = LittleView(empty: true)
    private let second = LittleView(empty: true)
    private let third = LittleView(empty: true)
    private let fourth = LittleView(empty: true)
    private let fifth = LittleView(empty: true)

    private let topSeparator = GrayViewSeparator()
    private let bottomSeparator = GrayViewSeparator()

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
        addSubviews([verticalStack, topSeparator, bottomSeparator])

        topSeparator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(2)
            make.left.right.equalToSuperview().inset(60)
        }

        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(topSeparator.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(bottomSeparator.snp.top).offset(-10)
        }

        verticalStack.addArrangedSubviews([firstHorizontalStack, secondHorizontalStack])
        firstHorizontalStack.addArrangedSubviews([rain, first, humidity, second, temperature])
        secondHorizontalStack.addArrangedSubviews([third, wind, fourth, direction, fifth])

        bottomSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(60)
            make.height.equalTo(2)
            make.bottom.equalToSuperview().offset(-10)
        }

        rain.setImageWith(image: "cloud.rain")
        humidity.setImageWith(image: "drop")
        temperature.setImageWith(image: "lineweight")
        wind.setImageWith(image: "wind")
        direction.setImageWith(image: "circle")
    }

    //MARK: Configure method

    func setValuesWith(text: [String]) {
        rain.setTextWith(text: text[0])
        humidity.setTextWith(text: text[1])
        temperature.setTextWith(text: text[2])
        wind.setTextWith(text: text[3])
        direction.setTextWith(text: text[4])
    }
}
