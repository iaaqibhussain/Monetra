//
//  UITextField+Extension.swift
//  Monetra
//
//  Created by temporaryadmin on 09.06.22.
//
import UIKit

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
