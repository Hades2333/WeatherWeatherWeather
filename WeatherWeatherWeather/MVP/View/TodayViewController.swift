//
//  TodayViewController.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit
import SnapKit

protocol TodayView {

}

class TodayViewController: UIViewController, TodayView {

    //MARK: GUI Variables

    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.color = .black
        spinner.style = .large
        return spinner
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.textAlignment = .center
        return label
    }()

    private let colorLine: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Images.rainbow)
        view.contentMode = .scaleToFill
        return view
    }()

    lazy var customTop: CustomTop = {
        let view = CustomTop()
        return view
    }()

    lazy var customMid: CustomMid = {
        let view = CustomMid()
        return view
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self,
                         action: #selector(sharePressed),
                         for: .touchUpInside)
        return button
    }()

    //MARK: Properties

    var presenter: TodayViewPresenter!

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TodayPresenter(view: self)
        configureGUI()
    }

    //MARK: Methods

    private func configureGUI() {

        view.backgroundColor = .secondarySystemBackground
        self.view.addSubviews([headerLabel, colorLine, customTop, customMid, shareButton])

        let myOffset = 10

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(myOffset)
            make.height.equalTo(myOffset*2)
            make.left.right.equalToSuperview()
        }

        colorLine.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(myOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
        }

        customTop.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(colorLine.snp.bottom).offset(myOffset)
            make.height.equalToSuperview().multipliedBy(0.35)
        }

        customMid.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(customTop.snp.bottom).offset(myOffset/2)
            make.height.equalToSuperview().multipliedBy(0.3)
        }

        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(customMid.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

    }

    //MARK: Actions

    @objc func sharePressed() {

    }
}
