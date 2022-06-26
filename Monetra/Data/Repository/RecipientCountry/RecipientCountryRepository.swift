//
//  RecipientCountryRepository.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

protocol RecipientCountryRepository {
    func fetchRecipientCountries(_ request: RecipientCountryRequest) async throws -> RecipientCountries
}

final class RecipientCountryRepositoryImpl: RecipientCountryRepository {
    private let requestManager: RequestManager
    
    init(requestManager: RequestManager = RequestManagerImpl()) {
        self.requestManager = requestManager
    }
    
    func fetchRecipientCountries(_ request: RecipientCountryRequest) async throws -> RecipientCountries {
        try await requestManager.perform(request)
    }
}
