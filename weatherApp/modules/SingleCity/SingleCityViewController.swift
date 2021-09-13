//
//  SingleCityViewController.swift
//  weatherApp
//
//  Created by Idan Levi on 26/08/2021.
//

import UIKit

class SingleCityViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentDegrees: UILabel!
    @IBOutlet weak var currentDescripition: UILabel!
    @IBOutlet weak var celsiusButton: UIBarButtonItem!
    @IBOutlet weak var fahrenheitButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var viewModel: SingleCityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.dataSource = self
        viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.willAppear()
    }
    
    @IBAction func celsiusPressed(_ sender: UIBarButtonItem) {
        viewModel.ChangeDegreesPresention(isCelsius: true)    }
    
    @IBAction func fahrenheitPressed(_ sender: UIBarButtonItem) {
        viewModel.ChangeDegreesPresention(isCelsius: false)
    }
}

extension SingleCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItem(for: indexPath)
        switch item {
        case .current(viewModel: let currentWeatherCellViewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.currentWeather) as? CurrentWeatherTableViewCell else {return UITableViewCell()}
            cell.configure(with: currentWeatherCellViewModel)
            return cell
        case .daily(viewModel: let dailyWeatherCellViewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.dailyWeather) as? DailyWeatherTableViewCell else {return UITableViewCell()}
            cell.configure(with: dailyWeatherCellViewModel)
            return cell
        }
    }
}

extension SingleCityViewController: SingleCityViewModelDelegate {
    
    func setDegrees(isCelsius: Bool) {
        if isCelsius {
            celsiusButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            fahrenheitButton.tintColor = #colorLiteral(red: 0.9903846154, green: 0.9807692308, blue: 1, alpha: 0.5048323675)
        } else {
            fahrenheitButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            celsiusButton.tintColor = #colorLiteral(red: 0.9903846154, green: 0.9807692308, blue: 1, alpha: 0.5048323675)
        }
    }
    
    func showLoader() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func removeLoader() {
        loader.stopAnimating()
        loader.isHidden = true
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(with message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
