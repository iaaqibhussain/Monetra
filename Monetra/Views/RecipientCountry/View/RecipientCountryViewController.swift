//
//  RecipientCountryViewController.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

final class RecipientCountryViewController: UITableViewController {
    var viewModel: RecipientViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModelCallback()
        viewModel.fetchRecipientCountries()
    }
}

extension RecipientCountryViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let item = viewModel.get(itemAt: indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = item.country
        content.secondaryText = item.countryCode
        cell.contentConfiguration = content
        return cell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
}

extension RecipientCountryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(itemAt: indexPath.row)
        dismiss(animated: true)
    }
}

private extension RecipientCountryViewController {
    class Constants {
        static let xmark = UIImage(systemName: "xmark")
        static let cellIdentifier = "RecipientCountryCell"
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Constants.xmark,
            style: .plain,
            target: self,
            action: #selector(closeBarButtonAction)
        )
    }
    
    @objc func closeBarButtonAction() {
        dismiss(animated: true)
    }
    
    func setupViewModelCallback() {
        viewModel.onStateChange = { [weak self] state in
            self?.update(state)
        }
    }
    
    func update(_ state: RecipientViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .loading:
                self?.showActivityIndicator()
            case .refresh:
                self?.tableView.reloadData()
                self?.hideActivityIndicator()
            case let .error(error):
                self?.hideActivityIndicator()
                self?.presentAlertController(message: error.localizedDescription)
            }
        }
    }
}
