//
//  CurrencyDataMapper.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//
typealias CurrenciesData = [String : CurrencyViewData]
protocol CurrencyDataMapper {
    func map(_ rates: [String : Double]) -> CurrenciesData
}

final class CurrencyDataMapperImpl: CurrencyDataMapper {
    func map(_ rates: [String : Double]) -> CurrenciesData {
        let currencyCodes = ["KES", "NGN", "TZS", "UGX"]
        let countries = ["KES" : "Kenya", "NGN" : "Nigeria", "TZS" : "Tanzania", "UGX" : "Uganda"]
        var currencies: CurrenciesData = [:]
        for currencyCode in currencyCodes {
            let country = countries[currencyCode] ?? ""
            let rate = rates[currencyCode] ?? 0.0
            let currency = CurrencyViewData(
                country: country,
                rate: rate,
                currencyCode: currencyCode
            )
            currencies[currencyCode] = currency
        }
        return currencies
    }
}
