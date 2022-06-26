//
//  SendTransactionHandler.swift
//  Monetra
//
//  Created by temporaryadmin on 09.06.22.
//

protocol SendTransactionHandler: AnyObject {
    func handle(_ country: RecipientCountry)
}
