//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by Idan Levi on 24/08/2021.
//

import Foundation

struct AllCitiesWeatherData: Codable  {
    let list: [CityWeatherData]
}

struct CityWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
