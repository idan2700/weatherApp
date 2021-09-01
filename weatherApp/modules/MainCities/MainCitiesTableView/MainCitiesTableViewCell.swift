//
//  MainCitiesTableViewCell.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import UIKit

class MainCitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var degrees: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescripition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(with cellViewModel: MainCitiesCellViewModel) {
        cellViewModel.delegate = self
        cityName.text = cellViewModel.cityName
        degrees.text = cellViewModel.degrees
        weatherDescripition.text = cellViewModel.description
        weatherIcon.image = cellViewModel.iconImage
    }
}

extension MainCitiesTableViewCell: MainCitiesCellViewModelDelegate {
    func updateIcon(with image: UIImage) {
        weatherIcon.image = image
    }
}
