//
//  MainSingleCityTableViewCell.swift
//  weatherApp
//
//  Created by Idan Levi on 12/09/2021.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var degrees: UILabel!
    @IBOutlet weak var descripition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(with cellViewModel: CurrentWeatherCellViewModel) {
        cellViewModel.delegate = self
        cityName.text = cellViewModel.cityName
        degrees.text = cellViewModel.degrees
        descripition.text = cellViewModel.description
        weatherIcon.image = cellViewModel.iconImage
    }
}

extension CurrentWeatherTableViewCell: CurrentWeatherCellViewModelDelegate {
    func updateIcon(with image: UIImage) {
        weatherIcon.image = image
    }
}

