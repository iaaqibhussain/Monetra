//
//  SendTransactionViewData.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

enum SendTransactionViewDataAction: Equatable {
    case dismiss
}

struct SendTransactionKeyboardViewData: Equatable {
    let keyboardType: UIKeyboardType
}

struct SendTransactionAllowedCharactersViewData: Equatable {
    let allowedCharacterSet: CharacterSet
}

struct SendTransactionCurrencyViewData: Equatable {
    let amountReceived: String
    let localAmountReceived: String
}

struct SendTransactionMessageViewData: Equatable {
    let title: String
    let message: String
    let action: SendTransactionViewDataAction?
}
