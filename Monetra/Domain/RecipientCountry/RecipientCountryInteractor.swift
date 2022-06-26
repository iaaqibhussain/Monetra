//
//  RecipientCountryInteractor.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

protocol RecipientCountryInteractor {
    func fetchRecipientCountries() async throws -> RecipientCountries
}

final class RecipientCountryInteractorImpl: RecipientCountryInteractor {
    private let repository: RecipientCountryRepository
    
    init(repository: RecipientCountryRepository = RecipientCountryRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchRecipientCountries() async throws -> RecipientCountries {
        let request = RecipientCountryRequest()
        return try await repository.fetchRecipientCountries(request)
    }
}
