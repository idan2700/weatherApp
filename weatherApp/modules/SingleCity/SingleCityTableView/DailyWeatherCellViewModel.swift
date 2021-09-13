//
//  SingleCityCellViewModel.swift
//  weatherApp
//
//  Created by Idan Levi on 30/08/2021.
//

import Foundation
import UIKit

protocol DailyWeatherCellViewModelDelegate: AnyObject {
    func updateIcon(with image: UIImage)
}

class DailyWeatherCellViewModel {
    
    var isCelsius: Bool = true
    weak var delegate: DailyWeatherCellViewModelDelegate?
    
    private var currentWeather: DayWeatherData
    
    init(currentWeather: DayWeatherData) {
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
