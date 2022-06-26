//
//  SendingCountryViewController.swift
//  Monetra
//
//  Created by temporaryadmin on 06.06.22.
//

import UIKit

final class SendingCountryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = SendCountryViewModelImpl()
    private let router = SendCountryRouterImpl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelCallback()
        viewModel.fetchSendCountries()
    }
    
    @IBAction func didTapExitBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension SendingCountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.sendingCellIdentifier, for: indexPath)
        let item = viewModel.get(itemAt: indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = item.country
        cell.contentConfiguration = content
        return cell
    }
}

extension SendingCountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCountry(at: indexPath.row)
    }
}

private extension SendingCountryViewController {
    class Constant {
        static let sendingCellIdentifier = "SendingCountryCell"
    }
    
    func setupViewModelCallback() {
        viewModel.onStateChange = { [weak self] state in
            self?.update(state)
        }
    }
    
    func update(_ state: SendCountryViewState) {
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
            case let .route(state):
                self?.router(on: state)
            }
        }
    }
    
    func router(on route: SendCountryRoute) {
        switch route {
        case let .transaction(country):
            guard let navigationController = navigationController else { return }
            router.start(from: navigationController, with: country)
        }
    }
}
