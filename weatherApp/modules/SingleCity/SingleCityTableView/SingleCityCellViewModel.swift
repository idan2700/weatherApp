//
//  SingleCityCellViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 30/08/2021.
//

import Foundation
import UIKit

protocol SingleCityCellViewModelDelegate: AnyObject {
    func updateIcon(with image: UIImage)
}

class SingleCityCellViewModel {
    var isCelsius: Bool
    weak var delegate: SingleCityCellViewModelDelegate?
    private var currentWeather: DayWeatherData
    var iconImage = UIImage() {
       didSet {
        delegate?.updateIcon(with: iconImage)
       }
   }
    
    init(currentWeather: DayWeatherData, isCelsius: Bool) {
        self.isCelsius = isCelsius
        self.currentWeather = currentWeather
        getIcon()
    }
    
    var day: String? {
        let formatter = DateFormatter()
        formatter.locale =  Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: currentWeather.dt_txt) else {return ""}
        formatter.dateFormat = "EEEE"
        let dayString = formatter.string(from: date)
        return dayString
    }
    
    var description: String? {
        return currentWeather.weather[0].description
    }
    
    var degrees: String {
        return createDegrees(min: currentWeather.main.temp_min, max: currentWeather.main.temp_max)
    }
    
    func createDegrees(min: Double, max: Double)-> String {
        let min = Int(min)
        let max = Int(max)
        if isCelsius == true {
        return "\(min)°-\(max)°"
        } else {
        return "\((min * Int(1.8)) + 32)°-\((max * Int(1.8)) + 32)°"
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
