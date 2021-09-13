//
//  FiveDaysWeatherData.swift
//  weatherApp
//
//  Created by Idan Levi on 30/08/2021.
//

import Foundation

struct FiveDaysWeatherData: Codable {
    let list: [DayWeatherData]
}

struct DayWeatherData: Codable {
    let dt_txt: String
    let main: Main
    let weather: [Weather]
}

extension DayWeatherData {
    func createDegrees(isCelsius: Bool)-> String {
        let min = Int(main.temp_min)
        let max = Int(main.temp_max)
        if isCelsius {
            return "\(min)°-\(max)°"
        } else {
           return "\((min * Int(1.8)) + 32)°-\((max * Int(1.8)) + 32)°"
        }
    }
}
