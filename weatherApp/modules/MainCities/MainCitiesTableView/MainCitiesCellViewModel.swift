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

class MainCitiesCellViewModel  {
    
    private var currentWeather: CityWeatherData
    var minDegrees = 0
    var maxDegrees = 0
    var isCelsius: Bool
    weak var delegate: MainCitiesCellViewModelDelegate?
    var iconImage = UIImage() {
        didSet {
            delegate?.updateIcon(with: iconImage)
        }
    }

    init(currentWeather: CityWeatherData, isCelsius: Bool) {
        self.currentWeather = currentWeather
        self.isCelsius = isCelsius
        self.getIcon()
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
