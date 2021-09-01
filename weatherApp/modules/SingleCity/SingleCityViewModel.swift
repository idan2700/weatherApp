//
//  SingleCityViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 26/08/2021.
//

import Foundation

protocol SingleCityViewModelDelegate: AnyObject {
    func chooseCelsius()
    func chooseFahrenheit()
    func reloadData()
    func showLoader()
    func removeLoader()
    func updateUI()
    func showError(with message: String)
    func updateMainDegreesUI()
}

class SingleCityViewModel {
    var choosenCityCellViewModel: MainCitiesCellViewModel
    weak var delegate: SingleCityViewModelDelegate?
    private var displayedDaysCellViewModels = [SingleCityCellViewModel]()
    var isTempInCelsius: Bool
    
    init(choosenCityCellViewModel: MainCitiesCellViewModel, isTempInCelsius: Bool) {
        self.choosenCityCellViewModel = choosenCityCellViewModel
        self.isTempInCelsius = isTempInCelsius
    }
    
    func didTapCelsius() {
        delegate?.chooseCelsius()
        for viewModel in displayedDaysCellViewModels {
            viewModel.isCelsius = true
        }
        delegate?.updateMainDegreesUI()
        delegate?.reloadData()
    }
    
    func didTapFahrenheit() {
        delegate?.chooseFahrenheit()
        for viewModel in displayedDaysCellViewModels {
            viewModel.isCelsius = false
        }
        delegate?.updateMainDegreesUI()
        delegate?.reloadData()
    }
    
    var numberOfRows: Int {
        return displayedDaysCellViewModels.count
    }
    
    func getCellViewModelForCell(at indexPath: IndexPath)-> SingleCityCellViewModel {
        return displayedDaysCellViewModels[indexPath.row]
    }
    
    func start() {
        delegate?.updateUI()
        delegate?.showLoader()
        guard let city = choosenCityCellViewModel.cityName else {return}
        ApiManager.shared.fetchFiveDaysWeatherData(with: city) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.delegate?.removeLoader()
                switch result {
                case .success(let weatherData):
                    let filterdWeather = weatherData.list.filter {$0.dt_txt.contains("00:00:00")}
                    for weather in filterdWeather {
                        self.displayedDaysCellViewModels.append(SingleCityCellViewModel(currentWeather: weather, isCelsius: self.isTempInCelsius))
                    }
                case .failure(let error):
                    self.delegate?.showError(with: error.localizedDescription)
                }
                self.delegate?.reloadData()
            }
        }
    }
    
    var degrees: String {
        return createDegrees(min: choosenCityCellViewModel.minDegrees, max: choosenCityCellViewModel.maxDegrees)
    }
    
    func createDegrees(min: Int, max: Int)-> String {
        if isTempInCelsius == true {
        return "\(min)°-\(max)°"
        } else {
        return "\((min * Int(1.8)) + 32)°-\((max * Int(1.8)) + 32)°"
        }
    }
}
