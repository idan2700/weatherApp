//
//  ApiManager.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import Foundation
import UIKit
import Alamofire

class ApiManager  {
    
    static let shared = ApiManager()
    
    func fetchCurrentWeatherData(with url: String, complition: @escaping (Result<AllCitiesWeatherData,ServiceError>)-> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.badUrl))
            return
        }
        AF.request(url, method: .get).responseJSON { response in
            guard let data = response.data else {
                complition(.failure(.failureReason))
                return
            }
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(AllCitiesWeatherData.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(weatherData))
                }
            } catch {
                complition(.failure(.failureReason))
            }
        }
    }
    
    func fetchFiveDaysWeatherData(with cityName: String, complition: @escaping (Result<FiveDaysWeatherData,ServiceError>)-> Void) {
        let url = "\(K.Url.fiveDaysUrl)\(cityName)"
        guard let url = URL(string: url) else {
            complition(.failure(.badUrl))
            return
        }
        AF.request(url, method: .get).responseJSON { response in
            guard let data = response.data else {
                complition(.failure(.failureReason))
                return
            }
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(FiveDaysWeatherData.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(weatherData))
                }
            } catch {
                complition(.failure(.failureReason))
            }
        }
    }

    func getImageIcon(with icon: String, complition: @escaping (Result<UIImage,ServiceError>)-> Void) {
        let imageUrlString = "\(K.Url.imageUrl)\(icon)@2x.png"
        let savedImageUrl = imageUrlString
        guard let url = URL(string: imageUrlString) else {
            complition(.failure(.badUrl))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            if savedImageUrl == imageUrlString {
                if let image = UIImage(data: data) {
                    complition(.success(image))
                }
            }
        }
        catch {
            complition(.failure(.failureReason))
        }
    }
}


