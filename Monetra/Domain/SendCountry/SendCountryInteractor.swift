//
//  SendCountryInteractor.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

protocol SendCountryInteractor {
    func fetchSendCountries() async throws -> SendCountries
}

final class SendCountryInteractorImpl: SendCountryInteractor {
    private let repository: SendCountryRepository
    
    init(repository: SendCountryRepository = SendCountryRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchSendCountries() async throws -> SendCountries {
        let request = SendCountryRequest()
        return try await repository.fetchSendCountries(request)
    }
}
