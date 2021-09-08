//
//  SingleCityViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 26/08/2021.
//

import Foundation

protocol SingleCityViewModelDelegate: AnyObject {
    func setDegrees(isCelsius: Bool)
    func reloadData()
    func showLoader()
    func removeLoader()
    func updateUI()
    func showError(with message: String)
    func updateMainDegreesUI()
}

class SingleCityViewModel {
    
    var choosenCityCellViewModel: MainCitiesCellViewModel
    var isCelsius: Bool
    weak var delegate: SingleCityViewModelDelegate?
    
    private var displayedDaysCellViewModels = [SingleCityCellViewModel]()
    private var mainCitiesViewModel = MainCitiesViewModel()
    
    init(choosenCityCellViewModel: MainCitiesCellViewModel, isCelsius: Bool, mainCitiesViewModel: MainCitiesViewModel) {
        self.choosenCityCellViewModel = choosenCityCellViewModel
        self.isCelsius = isCelsius
        self.mainCitiesViewModel = mainCitiesViewModel
    }
    
    func didChangeDegreesPresention(isCelsius: Bool) {
        self.isCelsius = isCelsius
        delegate?.setDegrees(isCelsius: isCelsius)
        for viewModel in displayedDaysCellViewModels {
            viewModel.isCelsius = isCelsius
        }
        mainCitiesViewModel.isCelsius = isCelsius
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
                    let filterdWeather = weatherData.filter {$0.dt_txt.contains("00:00:00")}
                    for weather in filterdWeather {
                        self.displayedDaysCellViewModels.append(SingleCityCellViewModel(currentWeather: weather))
                    }
                case .failure(let error):
                    self.delegate?.showError(with: error.localizedDescription)
                }
                self.didChangeDegreesPresention(isCelsius: self.isCelsius)
            }
        }
    }
    
    var degrees: String {
        return createDegrees(min: choosenCityCellViewModel.minDegrees, max: choosenCityCellViewModel.maxDegrees)
    }
    
    func createDegrees(min: Int, max: Int)-> String {
        if isCelsius {
        return "\(min)°-\(max)°"
        } else {
        return "\((min * Int(1.8)) + 32)°-\((max * Int(1.8)) + 32)°"
        }
    }
}
