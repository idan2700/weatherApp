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


