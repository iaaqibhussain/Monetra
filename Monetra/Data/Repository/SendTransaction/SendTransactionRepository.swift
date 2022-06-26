//
//  SendTransactionRepository.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

protocol SendTransactionRepository {
    func fetchCurrentRates(_ request: CurrencyRateRequest) async throws -> CurrencyRate
}

final class SendTransactionRepositoryImpl: SendTransactionRepository {
    private let requestManager: RequestManager
    
    init(requestManager: RequestManager = RequestManagerImpl()) {
        self.requestManager = requestManager
    }
    
    func fetchCurrentRates(_ request: CurrencyRateRequest) async throws -> CurrencyRate {
        try await requestManager.perform(request)
    }
}
