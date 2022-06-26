//
//  SendTransactionViewController.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

final class SendTransactionViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var recipientCountryTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var amountToSendTextField: UITextField!
    @IBOutlet weak var amountReceivedTextField: UITextField!
    @IBOutlet weak var recipientLocalCurrencyLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var viewModel: SendTransactionViewModel!
    var router = SendTransactionRouterImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupFirstNameTextField()
        setupLastNameTextField()
        setupRecipientTapGesture()
        setupAmountKeyboardType()
        setupPhoneNumberTextField()
        setupSendButton()
        setupRouter()
        setupViewModelCallback()
        viewModel.fetchCurrencyRates()
        setupViewControllerTapGesture()
    }
    
    @IBAction func sendButtonAction() {
        viewModel.submit()
    }
}

extension SendTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountToSendTextField {
            let allowedCharacters = viewModel.getSendingAmountAllowedCharactersViewData().allowedCharacterSet
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            let country = viewModel.recipientCountry?.countryCode ?? ""
            let count = country.count
            if textField.text?.count == count && string == "" {
                phoneNumberTextField.text = country
                return false
            }
            return true
        }
    }
}

private extension SendTransactionViewController {
    func setupNavigationBar() {
        title = viewModel.getNavigationBarTitle()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
    func setupRouter() {
        router.delegate = viewModel as? SendTransactionViewModelImpl
    }
    
    func setupAmountKeyboardType() {
        amountToSendTextField.isUserInteractionEnabled = false
        amountToSendTextField.keyboardType = viewModel.getSendingAmountKeyboardTypeViewData().keyboardType
        amountToSendTextField.addTarget(self, action: #selector(amountToSendTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func amountToSendTextFieldDidChange(_ sender: UITextField) {
        viewModel.createLocalCurrencyInBinary(text: sender.text ?? "")
    }

    func setupFirstNameTextField() {
        firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func firstNameTextFieldDidChange(_ sender: UITextField) {
        viewModel.firstName = sender.text ?? ""
    }
    
    func setupLastNameTextField() {
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func lastNameTextFieldDidChange(_ sender: UITextField) {
        viewModel.lastName = sender.text ?? ""
    }
    
    func setupRecipientTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(recipientTextFieldTapped(_:)))
        recipientCountryTextField.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupPhoneNumberTextField() {
        phoneNumberTextField.isUserInteractionEnabled = false
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func phoneNumberTextFieldDidChange(_ sender: UITextField) {
        viewModel.phoneNumber = sender.text ?? ""
    }
    
    @objc func recipientTextFieldTapped(_ sender: UITapGestureRecognizer) {
        viewModel.didTapRecipientTextField()
    }
    
    func setupSendButton() {
        sendButton.isUserInteractionEnabled = false
    }
    
    func setupViewControllerTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    func setupViewModelCallback() {
        viewModel.onStateChange = { [weak self] state in
            self?.update(state)
        }
    }
    
    func update(_ state: SendTransactionViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .loading:
                self?.navigationController?.showActivityIndicator()
            case .finish:
                self?.navigationController?.hideActivityIndicator()
            case let .update(componentState):
                self?.update(componentState)
            case let .route(state):
                self?.router(on: state)
            }
        }
    }
    
    func update(_ state: SendTransactionComponentState) {
        switch state {
        case let  .recipientTextField(country):
            recipientCountryTextField.text = country.country
            phoneNumberTextField.text = country.countryCode
            amountToSendTextField.isUserInteractionEnabled = true
            phoneNumberTextField.isUserInteractionEnabled = true
        case let .amountTextFields(viewData):
            amountReceivedTextField.text = viewData.amountReceived
            recipientLocalCurrencyLabel.text = viewData.localAmountReceived
        case let .message(viewData):
            navigationController?.hideActivityIndicator()
            presentAlertController(viewData)
        case let .submitButton(status):
            sendButton.isUserInteractionEnabled = status
        }
    }
    
    func router(on route: SendTransactionRoute) {
        switch route {
        case .recipient:
            router.start(from: self)
        }
    }
    
    func presentAlertController(_ viewData: SendTransactionMessageViewData) {
        self.presentAlertController(title: viewData.title, message: viewData.message, actionHandler: { _ in
            guard  let action = viewData.action, action == .dismiss  else { return }
            self.dismiss(animated: true)
        })
    }
}
