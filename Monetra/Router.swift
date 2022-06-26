//
//  Router.swift
//  PenguinPay
//
//  Created by temporaryadmin on 07.06.22.
//
import UIKit

protocol SendCountryRouter {
    func start(
        from controller: UINavigationController,
        with data: SendCountry
    )
}
