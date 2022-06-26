//
//  SendCountryViewModel.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

enum SendCountryViewState {
    case loading
    case refresh
    case error(Error)
    case route(SendCountryRoute)
}

protocol SendCountryViewModel {
    typealias SendCountryStateChange = (SendCountryViewState) -> Void
    var onStateChange: SendCountryStateChange? { get set }
    
    func didSelectCountry(at index: Int)
    func fetchSendCountries()
    func numberOfRows() -> Int
    func get(itemAt index: Int) -> SendCountry
}

final class SendCountryViewModelImpl: SendCountryViewModel {
    private let interactor: SendCountryInteractor
    private let mapper: CurrencyDataMapper
    init(
        interactor: SendCountryInteractor = SendCountryInteractorImpl(),
        mapper: CurrencyDataMapper = CurrencyDataMapperImpl()
    ) {
        self.interactor = interactor
        self.mapper = mapper
    }
    
    var onStateChange: SendCountryStateChange?
    private var countries: SendCountries = []
    
    func didSelectCountry(at index: Int) {
        let item = get(itemAt: index)
        onStateChange?(.route(.transaction(item)))
    }
    
    func fetchSendCountries() {
        Task {
            await fetchCountries()
        }
    }
    
    func numberOfRows() -> Int {
      countries.count
    }
    
    func get(itemAt index: Int) -> SendCountry {
        countries[index]
    }
}

private extension SendCountryViewModelImpl {
    func fetchCountries() async {
        do {
            countries = try await interactor.fetchSendCountries()
            onStateChange?(.refresh)
        } catch {
            onStateChange?(.error(error))
        }
    }
}
