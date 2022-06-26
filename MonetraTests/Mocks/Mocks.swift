//
//  Created by temporaryadmin on 09.06.22.
//

import XCTest
@testable import Monetra

final class SendTransactionInteractorMock: SendTransactionInteractor {
    
    private var currencyRate: CurrencyRate
    var fetchCurrentRatesCallsCount = 0
    var fetchCurrentRatesCalled: Bool {
        fetchCurrentRatesCallsCount > 0
    }
    
    init(currencyRate: CurrencyRate) {
        self.currencyRate = currencyRate
    }
    
    func fetchCurrentRates() async throws -> CurrencyRate {
        fetchCurrentRatesCallsCount += 1
        return currencyRate
    }
}
