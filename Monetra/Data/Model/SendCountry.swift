//
//  SendCountry.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

typealias SendCountries = [SendCountry]

struct SendCountry: Decodable {
    let country: String
    let keyboardType: KeyboardType
    let acceptableType: AcceptableType
}

extension SendCountry {
    enum KeyboardType: String, Decodable {
        case numberPad = "number_pad"
        case decimalPad = "decimal_pad"
    }
    
    enum AcceptableType: String, Decodable {
        case binary
        case decimal
    }
}
