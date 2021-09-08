//
//  MainCitiesCellViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import Foundation
import UIKit

protocol MainCitiesCellViewModelDelegate: AnyObject {
    func updateIcon(with image: UIImage)
}

class MainCitiesCellViewModel {
    
    var minDegrees = 0
    var maxDegrees = 0
    var isCelsius = true
    weak var delegate: MainCitiesCellViewModelDelegate?
    
    private var currentWeather: CityWeatherData
    
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
        return createDegrees(min: currentWeather.main.temp_min, max: currentWeather.main.temp_max)
    }
    
    func createDegrees(min: Double, max: Double)-> String {
        minDegrees = Int(min)
        maxDegrees = Int(max)
        if isCelsius == true {
        return "\(minDegrees)°-\(maxDegrees)°"
        } else {
            return "\((minDegrees * Int(1.8)) + 32)°-\((maxDegrees * Int(1.8)) + 32)°"
        }
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
