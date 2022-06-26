//
//  SendTransactionRouter.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

import UIKit
enum SendTransactionRoute {
    case recipient
}

protocol SendTransactionRouter {
    var delegate: SendTransactionHandler? { get set }
    func start(
        from controller: UIViewController
    )
}

final class SendTransactionRouterImpl: SendTransactionRouter {
    weak var delegate: SendTransactionHandler?
    
    func start(from controller: UIViewController) {
        let viewController: RecipientCountryViewController = .instantiateViewController()
        viewController.viewModel = RecipientViewModelImpl(delegate: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.backgroundColor = UIColor.accentColor
        navigationController.navigationBar.tintColor = UIColor.textColor
        controller.present(navigationController, animated: true)
    }
}

extension SendTransactionRouterImpl: RecipientExternalHandler {
    func handle(_ action: RecipientAction) {
        switch action {
        case let .selected(country):
            delegate?.handle(country)
        }
    }
}
