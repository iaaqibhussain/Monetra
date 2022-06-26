//
//  SendTransactionInteractor.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

protocol SendTransactionInteractor {
    func fetchCurrentRates() async throws -> CurrencyRate
}

final class SendTransactionInteractorImpl: SendTransactionInteractor {
    private let repository: SendTransactionRepository
    
    init(repository: SendTransactionRepository = SendTransactionRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchCurrentRates() async throws -> CurrencyRate {
        let request = CurrencyRateRequest()
        return try await repository.fetchCurrentRates(request)
    }
}

