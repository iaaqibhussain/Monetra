//
//  RecipientCountry.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//
typealias RecipientCountries = [RecipientCountry]

struct RecipientCountry: Decodable {
    let country: String
    let countryCode: String
    let currencyCode: String
    let phoneRegex: String
}
