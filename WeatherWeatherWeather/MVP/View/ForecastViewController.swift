//
//  ForecastViewController.swift
//  WeatherWeatherWeather
//
//  Created by Hellizar on 4.06.21.
//

import UIKit

protocol ForecastView {
    func updateTableView()
    func startSpinner()
    func stopSpinner()
}

class ForecastViewController: UIViewController {

    //MARK: GUI Variables

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let colorLine: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Images.rainbow)
        view.contentMode = .scaleToFill
        return view
    }()

    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .secondarySystemBackground
        table.register(CustomTableViewCell.self,
                       forCellReuseIdentifier: CustomTableViewCell.identifier)
        return table
    }()

    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.stopAnimating()
        spinner.color = .black
        spinner.style = .large
        return spinner
    }()

    //MARK: Properties

    var presenter: ForecastViewPresenter!

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = ForecastPresenter(view: self)
        configureUI()
    }

    //MARK: Methods

    func configureUI() {

        view.backgroundColor = .secondarySystemBackground
        view.addSubviews([headerLabel, colorLine, table])
        table.addSubview(spinner)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview()
        }
        colorLine.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(colorLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

//MARK: UITableViewDelegate and UITableViewDataSourece

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter != nil ? presenter.countSections() : 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.calculateHeader(forSection: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.calculateNumberOfRows(forSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,
                                                       for: indexPath) as? CustomTableViewCell else {
            fatalError("custom cell not found")}

        guard !presenter.arrayForTable.isEmpty else { return UITableViewCell() }

        cell.configure(withModel: presenter.getModelIn(section: indexPath.section, row: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { return }
}

extension ForecastViewController: ForecastView {

    func updateTableView() {
        self.table.reloadData()
        guard let presenter = presenter else { return }
        headerLabel.text = presenter.getPlaceName()
        stopSpinner()
    }

    func startSpinner() { self.spinner.startAnimating() }

    func stopSpinner() { self.spinner.stopAnimating() }
}
