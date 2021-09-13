//
//  SingleCityViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 26/08/2021.
//

import Foundation

protocol isCelsiusDelegate: AnyObject {
    func didPick(isCelsius: Bool)
}

protocol SingleCityViewModelDelegate: AnyObject {
    func setDegrees(isCelsius: Bool)
    func reloadData()
    func showLoader()
    func removeLoader()
    func showError(with message: String)
}

class SingleCityViewModel {
    
    var isCelsius: Bool {
        didSet {
            isCelsiusDelegate?.didPick(isCelsius: isCelsius)
        }
    }
    weak var delegate: SingleCityViewModelDelegate?
    weak var isCelsiusDelegate: isCelsiusDelegate?
    
    private var items = [SingleCityItemType]()
    private var choosenCityWeatherData: CityWeatherData
    
    init(choosenCityWeatherData: CityWeatherData, isCelsius: Bool, isCelsiusDelegate: isCelsiusDelegate) {
        self.choosenCityWeatherData = choosenCityWeatherData
        self.isCelsius = isCelsius
        self.isCelsiusDelegate = isCelsiusDelegate
        self.items.append(SingleCityItemType.current(viewModel: CurrentWeatherCellViewModel(currentWeather: choosenCityWeatherData)))
    }
    
    func willAppear() {
        delegate?.setDegrees(isCelsius: isCelsius)
    }
    
    func ChangeDegreesPresention(isCelsius: Bool) {
        self.isCelsius = isCelsius
        delegate?.setDegrees(isCelsius: isCelsius)
        changeDegreesTypeInViewModels()
    }
    
    func changeDegreesTypeInViewModels() {
        for item in items {
            switch item {
            case .current(viewModel: let viewModel):
                viewModel.isCelsius = self.isCelsius
            case .daily(viewModel: let viewModel):
                viewModel.isCelsius = self.isCelsius
            }
            delegate?.reloadData()
        }
    }
    
    var numberOfRows: Int {
        return items.count
    }
    
    func getItem(for indexPath: IndexPath) -> SingleCityItemType {
        return items[indexPath.row]
    }
    
    func start() {
        delegate?.showLoader()
        ApiManager.shared.fetchFiveDaysWeatherData(with: choosenCityWeatherData.name) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.delegate?.removeLoader()
                switch result {
                case .success(let weatherData):
                    let filterdWeather = weatherData.filter {$0.dt_txt.contains("00:00:00")}
                    for weather in filterdWeather {
                        self.items.append(SingleCityItemType.daily(viewModel: DailyWeatherCellViewModel(currentWeather: weather)))
                    }
                case .failure(let error):
                    self.delegate?.showError(with: error.localizedDescription)
                }
                self.changeDegreesTypeInViewModels()
                self.delegate?.reloadData()
            }
        }
    }
}
