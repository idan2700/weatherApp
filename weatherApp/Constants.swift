//
//  constantsFile.swift
//  weatherApp
//
//  Created by Idan Levi on 24/08/2021.
//

import Foundation

struct K {
    
    struct Url {
    static let allCitiesUrl = "https://api.openweathermap.org/data/2.5/group?id=703448,2643743,2968815,2759794,1609348,1261481,1850147,5128581,5506956,3530597,293397,524894,3451189,2147714,6167865,146400,3369157&units=metric&appid=45b7886e4fec13cc8de27828cf463507"
    static let fiveDaysUrl = "https://api.openweathermap.org/data/2.5/forecast?&appid=45b7886e4fec13cc8de27828cf463507&units=metric&q="
    static let imageUrl = "https://openweathermap.org/img/wn/"
    }
    
    struct Cell {
        static let mainCities = "mainCitiesCell"
        static let dailyWeather = "dailyWeatherCell"
        static let currentWeather = "currentWeatherCell"
    }
    
    struct Segue {
       static let mainToSingle = "mainToSingle"
    }
    
}

