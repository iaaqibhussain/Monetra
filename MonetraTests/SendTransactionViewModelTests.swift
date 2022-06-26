//
//  Created by temporaryadmin on 09.06.22.
//

import XCTest
@testable import Monetra

final class SendTransactionViewModelTests: XCTestCase {
    private var viewModel: SendTransactionViewModelImpl!
    private var sendCountry = SendCountry(country: "Binaria", keyboardType: .numberPad, acceptableType: .binary)
    private var interactor: SendTransactionInteractorMock!
    private var dataMapper = CurrencyDataMapperImpl()
    private var viewDataMapper = SendTransactionViewDataMapperImpl()
    override func setUp() {
        let kenya = CurrencyRate(disclaimer: "", license: "", timestamp: 0, base: "", rates: ["KES" : 117.10])
        interactor = SendTransactionInteractorMock(currencyRate: kenya)
        viewModel = SendTransactionViewModelImpl(
            country: sendCountry,
            interactor: interactor,
            viewDataMapper: viewDataMapper,
            dataMapper: dataMapper
        )
    }
    
    func testCreateLocalCurrencyInBinary() throws {
        let expected = makeSendCurrencyViewData()

        viewModel.onStateChange = { state in
            switch state {
            case let .update(componentState):
                switch componentState {
                case let .amountTextFields(result):
                    XCTAssertEqual(expected, result)
                case .message(_), .recipientTextField(_), .submitButton(_):
                    break
                }
            case .finish:
                XCTAssertEqual(self.interactor.fetchCurrentRatesCalled, true)
                self.viewModel.createLocalCurrencyInBinary(text: "10")
            case .loading, .route(_):
                break
            }
        }
        viewModel.recipientCountry = RecipientCountry(
            country: "Kenya",
            countryCode: "+254",
            currencyCode: "KES",
            phoneRegex: "254\\d{8}$"
        )
        viewModel.fetchCurrencyRates()
    }
}

private extension SendTransactionViewModelTests {
    func makeSendCurrencyViewData(
        value: String = "10",
        rate: Double = 117.10,
        currencyCode: String = "KES"
    ) -> SendTransactionCurrencyViewData {
        var currencyViewData: SendTransactionCurrencyViewData
        let localAmountReceivedText = "Recipient will receive in local currency: "
        
        let totalAmount = (Int64(value, radix: 2) ?? 0) * (Int64(rate))
        let localRate = String(totalAmount, radix: 2)
        currencyViewData = SendTransactionCurrencyViewData(
            amountReceived: String(localRate),
            localAmountReceived: "\(localAmountReceivedText) \(totalAmount) \(currencyCode)"
        )
        return currencyViewData
    }
}
