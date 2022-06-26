//
//  SendCountryRepository.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

protocol SendCountryRepository {
    func fetchSendCountries(_ request: SendCountryRequest) async throws -> SendCountries
}

final class SendCountryRepositoryImpl: SendCountryRepository {
    private let requestManager: RequestManager
    
    init(requestManager: RequestManager = RequestManagerImpl()) {
        self.requestManager = requestManager
    }
    
    func fetchSendCountries(_ request: SendCountryRequest) async throws -> SendCountries {
        try await requestManager.perform(request)
    }
}

