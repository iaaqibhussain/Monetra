//
//  CurrencyRates.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

struct CurrencyRate: Decodable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String : Double]
}
