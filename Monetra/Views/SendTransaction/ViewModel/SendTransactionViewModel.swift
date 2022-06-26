//
//  SendTransactionViewModel.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//
import Foundation

enum SendTransactionComponentState {
    case recipientTextField(RecipientCountry)
    case amountTextFields(SendTransactionCurrencyViewData)
    case message(SendTransactionMessageViewData)
    case submitButton(Bool)
}

enum SendTransactionViewState {
    case loading
    case update(SendTransactionComponentState)
    case finish
    case route(SendTransactionRoute)
}

protocol SendTransactionViewModel {
    typealias SendTransactionStateChange = (SendTransactionViewState) -> Void
    var onStateChange: SendTransactionStateChange? { get set }
    
    var firstName: String { get set }
    var lastName: String { get set }
    var phoneNumber: String { get set }
    
    var recipientCountry: RecipientCountry? { get set }
    func getNavigationBarTitle() -> String
    func getSendingAmountKeyboardTypeViewData() -> SendTransactionKeyboardViewData
    func getSendingAmountAllowedCharactersViewData() -> SendTransactionAllowedCharactersViewData
    
    func didTapRecipientTextField()
    func fetchCurrencyRates()
    func createLocalCurrencyInBinary(text: String)
    func submit()
}

final class SendTransactionViewModelImpl: SendTransactionViewModel {
    var onStateChange: SendTransactionStateChange?
    
    private let country: SendCountry
    private let interactor: SendTransactionInteractor
    private let viewDataMapper: SendTransactionViewDataMapper
    private let dataMapper: CurrencyDataMapper
    
    private var currencyRates: CurrenciesData = [:]
    var recipientCountry: RecipientCountry? {
        didSet {
            phoneNumber = recipientCountry?.countryCode ?? ""
        }
    }
    
    var firstName: String = "" {
        didSet {
            enableSubmit()
        }
    }
    
    var lastName: String = "" {
        didSet {
            enableSubmit()
        }
    }
    
    var phoneNumber: String = "" {
        didSet {
            enableSubmit()
        }
    }
    
    var amountToSend: String = "" {
        didSet {
            enableSubmit()
        }
    }
    
    init(
        country: SendCountry,
        interactor: SendTransactionInteractor = SendTransactionInteractorImpl(),
        viewDataMapper: SendTransactionViewDataMapper = SendTransactionViewDataMapperImpl(),
        dataMapper: CurrencyDataMapper = CurrencyDataMapperImpl()
    ) {
        self.country = country
        self.interactor = interactor
        self.viewDataMapper = viewDataMapper
        self.dataMapper = dataMapper
    }
    
    func getNavigationBarTitle() -> String {
        "Send Transactions"
    }
    
    func getSendingAmountKeyboardTypeViewData() -> SendTransactionKeyboardViewData {
        viewDataMapper.map(country.keyboardType)
    }
    
    func getSendingAmountAllowedCharactersViewData() -> SendTransactionAllowedCharactersViewData {
        viewDataMapper.map(country.acceptableType)
    }
    
    func didTapRecipientTextField() {
        onStateChange?(.route(.recipient))
    }
    
    func fetchCurrencyRates() {
        Task {
            await fetchCurrencyRates()
        }
    }
    
    func createLocalCurrencyInBinary(text: String) {
        amountToSend = text
        guard
            let currencyCode = recipientCountry?.currencyCode,
            let currencyViewData = currencyRates[currencyCode]
        else { return }
        let viewData = viewDataMapper.map(country.acceptableType, text, currencyViewData)
        onStateChange?(.update(.amountTextFields(viewData)))
    }
    
    func submit() {
        guard validate(phoneNumber.trimmingCharacters(in: .symbols)) else {
            let viewData = SendTransactionMessageViewData(
                title: "Invalid Phone Number",
                message: "Make sure to use a valid phone number",
                action: nil
            )
            onStateChange?(.update(.message(viewData)))
            return
        }
        
        onStateChange?(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            let viewData = SendTransactionMessageViewData(
                title: "Success!",
                message: "Your transfer has been successfully done.",
                action: .dismiss
            )
            self?.onStateChange?(.update(.message(viewData)))
        }
    }
}

extension SendTransactionViewModelImpl: SendTransactionHandler {
    func handle(_ country: RecipientCountry) {
        recipientCountry = country
        onStateChange?(.update(.recipientTextField(country)))
    }
}

private extension SendTransactionViewModelImpl {
    func fetchCurrencyRates() async {
        onStateChange?(.loading)
        do {
            let rates = try await interactor.fetchCurrentRates().rates
            currencyRates = dataMapper.map(rates)
            onStateChange?(.finish)
        } catch {
            let viewData = SendTransactionMessageViewData(
                title: "Error Occured",
                message: error.localizedDescription,
                action: .dismiss
            )
            onStateChange?(.update(.message(viewData)))
        }
    }
    
    func validate(_ phoneNumber: String) -> Bool {
        let regularExpression = recipientCountry?.phoneRegex ?? ""
        let predicate = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        let trimmed = phoneNumber.trimmingCharacters(in:.symbols)
            .trimmingCharacters(in:.whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
        return predicate.evaluate(with: trimmed)
    }
    
    func enableSubmit() {
        let dataFilled = firstName != "" && lastName != "" && phoneNumber != "" && amountToSend != "" && recipientCountry != nil
        onStateChange?(.update(.submitButton(dataFilled)))
    }
}
