//
//  SingleCityTableViewCell.swift
//  weatherApp
//
//  Created by Idan Levi on 30/08/2021.
//

import UIKit

class SingleCityTableViewCell: UITableViewCell  {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherDescripition: UILabel!
    @IBOutlet weak var degrees: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configure(with cellViewModel: SingleCityCellViewModel) {
        cellViewModel.delegate = self
        day.text = cellViewModel.day
        degrees.text = cellViewModel.degrees
        weatherDescripition.text = cellViewModel.description
        weatherIcon.image = cellViewModel.iconImage
    }
}

extension SingleCityTableViewCell: SingleCityCellViewModelDelegate {
    func updateIcon(with image: UIImage) {
        weatherIcon.image = image
    }
}



