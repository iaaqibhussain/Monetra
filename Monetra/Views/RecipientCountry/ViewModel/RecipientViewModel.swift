//
//  RecipientViewModel.swift
//  Monetra
//
//  Created by temporaryadmin on 08.06.22.
//

enum RecipientViewState {
    case loading
    case refresh
    case error(Error)
}

protocol RecipientViewModel {
    typealias RecipientStateChange = (RecipientViewState) -> Void
    var onStateChange: RecipientStateChange? { get set }
    
    func fetchRecipientCountries()
    func numberOfRows() -> Int
    func get(itemAt index: Int) -> RecipientCountry
    func didSelect(itemAt index: Int)
}

final class RecipientViewModelImpl: RecipientViewModel {
    private let interactor: RecipientCountryInteractor
    private var countries: RecipientCountries = []
    private weak var delegate: RecipientExternalHandler?
    init(
        interactor: RecipientCountryInteractor = RecipientCountryInteractorImpl(),
        delegate: RecipientExternalHandler
    ) {
        self.interactor = interactor
        self.delegate = delegate
    }
    var onStateChange: RecipientStateChange?
    
    func fetchRecipientCountries() {
        Task {
            await fetchCountries()
        }
    }
    
    func numberOfRows() -> Int {
        countries.count
    }
    
    func get(itemAt index: Int) -> RecipientCountry {
        countries[index]
    }
    
    func didSelect(itemAt index: Int) {
        let country = get(itemAt: index)
        delegate?.handle(.selected(country))
    }
}

private extension RecipientViewModelImpl {
    func fetchCountries() async {
        onStateChange?(.loading)
        do {
            countries = try await interactor.fetchRecipientCountries()
            onStateChange?(.refresh)
        } catch {
            onStateChange?(.error(error))
        }
    }
}
