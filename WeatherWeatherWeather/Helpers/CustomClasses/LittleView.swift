//
//  LittleImage.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit
import SnapKit

class LittleView: UIView {

    //MARK: GUI variables

    private lazy var littleImage: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemYellow
        view.image = UIImage(named: Images.sun)
        return view
    }()

    private lazy var littleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "humidity"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    //MARK: Initialization

    init(empty: Bool) {
        super.init(frame: .zero)
        if !empty {
            configureUI()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods

    private func configureUI() {
        self.addSubviews([littleImage, littleLabel])

        littleImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(littleImage.snp.width)
        }

        littleLabel.snp.makeConstraints { make in
            make.top.equalTo(littleImage.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func setValusFor(image: UIImage?, text: String?) {
        if let image = image {
            self.littleImage.image = image
        } else if let text = text {
            self.littleLabel.text = text
        }
    }
}
