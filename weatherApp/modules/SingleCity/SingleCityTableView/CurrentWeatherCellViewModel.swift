//
//  MainSingleCityCellViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 12/09/2021.
//

import Foundation
import UIKit

protocol CurrentWeatherCellViewModelDelegate: AnyObject {
    func updateIcon(with image: UIImage)
}

class CurrentWeatherCellViewModel {
    
    var isCelsius = true
    weak var delegate: CurrentWeatherCellViewModelDelegate?
    
    private (set) var currentWeather: CityWeatherData
    
    init(currentWeather: CityWeatherData) {
        self.currentWeather = currentWeather
        getIcon()
    }
    
    var cityName: String? {
        return currentWeather.name
    }
    
    var description: String? {
        return currentWeather.weather[0].description
    }
    
    var degrees: String {
        return String().createDegrees(isCelsius: isCelsius, min: currentWeather.main.temp_min, max: currentWeather.main.temp_max)
    }

    var iconImage = UIImage() {
        didSet {
            delegate?.updateIcon(with: iconImage)
        }
    }
    
    func getIcon() {
        ApiManager.shared.getImageIcon(with: currentWeather.weather[0].icon) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.iconImage = image
                }
            case .failure(_):
                if let image = UIImage(systemName: "nosign") {
                    self.iconImage = image
                }
            }
        }
    }
}

