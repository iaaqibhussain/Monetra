//
//  SendCountryRouter.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

enum SendCountryRoute {
    case transaction(SendCountry)
}

protocol SendCountryRouter {
    func start(
        from controller: UINavigationController,
        with data: SendCountry
    )
}

final class SendCountryRouterImpl: SendCountryRouter {
    func start(
        from controller: UINavigationController,
        with data: SendCountry
    ) {
        let viewController: SendTransactionViewController = .instantiateViewController()
        let viewModel = SendTransactionViewModelImpl(country: data)
        viewController.viewModel = viewModel
        controller.pushViewController(viewController, animated: true)
    }
}
