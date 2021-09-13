//
//  Helpers.swift
//  weatherApp
//
//  Created by Idan Levi on 13/09/2021.
//

import Foundation

extension String {
    func createDegrees(isCelsius: Bool, min: Double, max: Double)-> String {
        let minDegrees = Int(min)
        let maxDegrees = Int(max)
        if isCelsius {
            return "\(minDegrees)°-\(maxDegrees)°"
        } else {
            return "\((minDegrees * Int(1.8)) + 32)°-\((maxDegrees * Int(1.8)) + 32)°"
        }
    }
}
