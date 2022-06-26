//
//  SendTransactionViewDataMapper.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

protocol SendTransactionViewDataMapper {
    func map(_ keyboardType: SendCountry.KeyboardType) -> SendTransactionKeyboardViewData
    func map(_ acceptableType: SendCountry.AcceptableType) -> SendTransactionAllowedCharactersViewData
    func map(_ acceptableType: SendCountry.AcceptableType, _ value: String, _ viewData: CurrencyViewData) -> SendTransactionCurrencyViewData
}

final class SendTransactionViewDataMapperImpl: SendTransactionViewDataMapper {
    func map(_ keyboardType: SendCountry.KeyboardType) -> SendTransactionKeyboardViewData {
        let keyboardType = get(from: keyboardType)
        return SendTransactionKeyboardViewData(keyboardType: keyboardType)
    }
    
    func map(_ acceptableType: SendCountry.AcceptableType) -> SendTransactionAllowedCharactersViewData {
        let characterSet = get(from: acceptableType)
        return SendTransactionAllowedCharactersViewData(allowedCharacterSet: characterSet)
    }
    
    func map(
        _ acceptableType: SendCountry.AcceptableType,
        _ value: String,
        _ viewData: CurrencyViewData
    ) -> SendTransactionCurrencyViewData {
        var currencyViewData: SendTransactionCurrencyViewData
        let localAmountReceivedText = "Recipient will receive in local currency: "
        switch acceptableType {
        case .binary:
            let totalAmount = (Int64(value, radix: 2) ?? 0) * (Int64(viewData.rate))
            let localRate = String(totalAmount, radix: 2)
            currencyViewData = SendTransactionCurrencyViewData(
                amountReceived: String(localRate),
                localAmountReceived: "\(localAmountReceivedText) \(totalAmount) \(viewData.currencyCode)"
            )
        case .decimal:
            let totalAmount = (Double(value) ?? 0.0) * viewData.rate
            let localRate = String(totalAmount)
            currencyViewData = SendTransactionCurrencyViewData(
                amountReceived: String(totalAmount),
                localAmountReceived: "\(localAmountReceivedText) \(localRate) \(viewData.currencyCode)"
            )
        }
        return currencyViewData
    }
}

private extension SendTransactionViewDataMapperImpl {
    func get(from keyboardType: SendCountry.KeyboardType) -> UIKeyboardType {
        var type: UIKeyboardType
        switch keyboardType {
        case .numberPad:
            type = .numberPad
        case .decimalPad:
            type = .decimalPad
        }
        return type
    }
    
    func get(from acceptableType: SendCountry.AcceptableType) -> CharacterSet {
        var characterSet: CharacterSet
        switch acceptableType {
        case .binary:
            characterSet = CharacterSet(charactersIn: "10")
        case .decimal:
            characterSet = CharacterSet(charactersIn: "1234567890,.")
        }
        return characterSet
    }
}
