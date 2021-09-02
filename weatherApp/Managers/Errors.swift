//
//  Errors.swift
//  weatherApp
//
//  Created by Idan Levi on 01/09/2021.
//

import Foundation

enum ServiceError: Error  {
    case badUrl
    case failureReason
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Data url is invalid"
        case .failureReason:
            return "Failed to fetch data from the server"
        }
    }
}
