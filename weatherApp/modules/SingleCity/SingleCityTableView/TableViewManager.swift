//
//  TableViewManager.swift
//  weatherApp
//
//  Created by Idan Levi on 11/09/2021.
//

import Foundation

enum SingleCityItemType {
    case current(viewModel: CurrentWeatherCellViewModel)
    case daily(viewModel: DailyWeatherCellViewModel)
}
