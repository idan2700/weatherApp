//
//  ViewController.swift
//  weatherApp
//
//  Created by Idan Levi on 23/08/2021.
//

import UIKit

class MainCitiesViewController: UIViewController {
    @IBOutlet weak var celsiusButton: UIBarButtonItem!
    @IBOutlet weak var fahrenheitButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var noCityLabel: UILabel!
    var viewModel = MainCitiesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        viewModel.start()
    }

    @IBAction func celsiusPressed(_ sender: UIBarButtonItem) {
        viewModel.didTapCelsius()
    }
    @IBAction func fahrenheitPressed(_ sender: UIBarButtonItem) {
        viewModel.didTapFahrenheit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.mainToSingle {
            guard let singleCityVC = segue.destination as? SingleCityViewController else {return}
            singleCityVC.viewModel = SingleCityViewModel(choosenCityCellViewModel: viewModel.choosenViewModel, isTempInCelsius: viewModel.isTempInCelsius)
        }
    }
}

extension MainCitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.mainCities) as? MainCitiesTableViewCell else {return UITableViewCell()}
        let cellViewModel = viewModel.getCellViewModelForCell(at: indexPath)
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension MainCitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension MainCitiesViewController: UISearchBarDelegate {    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
        viewModel.didChangeText(text)
        }
    }
}

extension MainCitiesViewController: MainCitiesViewModelDelegate {
    func showNoCityLabel() {
        noCityLabel.isHidden = false
    }
    
    func hideNoCityLabel() {
        noCityLabel.isHidden = true
    }
    
    func showLoader() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func removeLoader() {
        loader.stopAnimating()
        loader.isHidden = true
    }
    
    func moveToSingleCityVC() {
        performSegue(withIdentifier: K.Segue.mainToSingle, sender: self)
    }
    
    func chooseCelsius() {
        viewModel.isTempInCelsius = true
        celsiusButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        fahrenheitButton.tintColor = #colorLiteral(red: 0.9903846154, green: 0.9807692308, blue: 1, alpha: 0.5048323675)
    }
    
    func chooseFahrenheit() {
        viewModel.isTempInCelsius = false
        fahrenheitButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        celsiusButton.tintColor = #colorLiteral(red: 0.9903846154, green: 0.9807692308, blue: 1, alpha: 0.5048323675)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showError(with message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

