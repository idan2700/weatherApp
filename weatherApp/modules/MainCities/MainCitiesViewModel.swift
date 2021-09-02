//
//  MainCitiesViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import Foundation
import UIKit

protocol MainCitiesViewModelDelegate: AnyObject {
    func chooseCelsius()
    func chooseFahrenheit()
    func reloadData()
    func moveToSingleCityVC()
    func showLoader()
    func removeLoader()
    func showNoCityLabel()
    func hideNoCityLabel()
    func showError(with message: String)
}

class MainCitiesViewModel  {
    
    weak var delegate: MainCitiesViewModelDelegate?
    var choosenViewModel: MainCitiesCellViewModel!
    private var allcitiesCellViewModels = [MainCitiesCellViewModel]()
    private var displayedCitiesCellViewModels = [MainCitiesCellViewModel]()
    var isTempInCelsius = true
    
    func didTapCelsius() {
        delegate?.chooseCelsius()
        for viewModel in displayedCitiesCellViewModels {
            viewModel.isCelsius = true
        }
        delegate?.reloadData()
    }
    
    func didTapFahrenheit() {
        delegate?.chooseFahrenheit()
        for viewModel in displayedCitiesCellViewModels {
            viewModel.isCelsius = false
        }
        delegate?.reloadData()
    }
    
    var numberOfRows: Int {
        return displayedCitiesCellViewModels.count
    }
    
    func getCellViewModelForCell(at indexPath: IndexPath)-> MainCitiesCellViewModel {
        return displayedCitiesCellViewModels[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        choosenViewModel = displayedCitiesCellViewModels[indexPath.row]
        delegate?.moveToSingleCityVC()
    }
    
    func start() {
        delegate?.showLoader()
        ApiManager.shared.fetchCurrentWeatherData(with: K.Url.allCitiesUrl) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.delegate?.removeLoader()
                switch result {
                case .success(let weatherData):
                    for weather in weatherData.list {
                        self.displayedCitiesCellViewModels.append(MainCitiesCellViewModel(currentWeather: weather, isCelsius: self.isTempInCelsius))
                    }
                case .failure(let error):
                    self.delegate?.showError(with: error.localizedDescription)
                }
                self.allcitiesCellViewModels = self.displayedCitiesCellViewModels
                self.delegate?.reloadData()
            }
        }
    }
    
    func didChangeText(_ searchText: String) {
        let filterd = allcitiesCellViewModels.filter {($0.cityName?.contains(searchText)) ?? false}
        if filterd.count > 0 {
            displayedCitiesCellViewModels = filterd
            delegate?.hideNoCityLabel()
        } else if searchText.isEmpty == false {
            displayedCitiesCellViewModels = filterd
            delegate?.showNoCityLabel()
        } else {
            delegate?.hideNoCityLabel()
            displayedCitiesCellViewModels = allcitiesCellViewModels
        }
        delegate?.reloadData()
    }
}


