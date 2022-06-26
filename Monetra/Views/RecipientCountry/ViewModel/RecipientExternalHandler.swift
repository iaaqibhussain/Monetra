//
//  RecipientExternalHandler.swift
//  Monetra
//
//  Created by temporaryadmin on 09.06.22.
//

enum RecipientAction {
    case selected(RecipientCountry)
}

protocol RecipientExternalHandler: AnyObject {
    func handle(_ action: RecipientAction)
}
