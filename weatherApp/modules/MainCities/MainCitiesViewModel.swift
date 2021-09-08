//
//  MainCitiesViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import Foundation
import UIKit

protocol MainCitiesViewModelDelegate: AnyObject {
    func setDegrees(isCelsius: Bool)
    func reloadData()
    func moveToSingleCityVC()
    func showLoader()
    func removeLoader()
    func showNoCityLabel()
    func hideNoCityLabel()
    func showError(with message: String)
}

class MainCitiesViewModel {
    
    private var allcitiesCellViewModels = [MainCitiesCellViewModel]()
    private var displayedCitiesCellViewModels = [MainCitiesCellViewModel]()
    
    weak var delegate: MainCitiesViewModelDelegate?
    var choosenViewModel: MainCitiesCellViewModel!
    var isCelsius = true
    
    func willAppear() {
        self.didChangeDegreesPresention(isCelsius: self.isCelsius)
    }
    
    func didChangeDegreesPresention(isCelsius: Bool) {
        self.isCelsius = isCelsius
        delegate?.setDegrees(isCelsius: isCelsius)
        for viewModel in displayedCitiesCellViewModels {
            viewModel.isCelsius = isCelsius
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
                    for weather in weatherData {
                        self.allcitiesCellViewModels.append(MainCitiesCellViewModel(currentWeather: weather))
                    }
                case .failure(let error):
                    self.delegate?.showError(with: error.localizedDescription)
                }
                self.displayedCitiesCellViewModels = self.allcitiesCellViewModels
                self.delegate?.reloadData()
            }
        }
    }
 
    func didChangeText(_ searchText: String) {
        if searchText.isEmpty {
            delegate?.hideNoCityLabel()
            displayedCitiesCellViewModels = allcitiesCellViewModels
        } else {
            let filterd = allcitiesCellViewModels.filter {($0.cityName?.contains(searchText)) ?? false}
            if filterd.count > 0 {
                displayedCitiesCellViewModels = filterd
                delegate?.hideNoCityLabel()
            } else {
                displayedCitiesCellViewModels = [MainCitiesCellViewModel]()
                delegate?.showNoCityLabel()
            }
        }
        delegate?.reloadData()
    }
}


