//
//  UIViewController+Extension.swift
//  Monetra
//
//  Created by temporaryadmin on 07.06.22.
//

import UIKit

extension UIViewController {
    
    static func instantiateViewController<T: UIViewController>(with storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)) -> T {
        let viewController: T = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        return viewController
    }
    
    func presentAlertController(
        title: String = "Error Occurred",
        message: String,
        actionHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        let spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        spinnerView.tag = Constant.spinnerViewTag
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.startAnimating()
        activityView.center = spinnerView.center
        activityView.tag = Constant.activityIndicatorViewTag
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityView)
            self.view.addSubview(spinnerView)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.removeActivityIndicatorView()
        }
    }
}

private extension UIViewController {
    class Constant {
        static let spinnerViewTag = 999
        static let activityIndicatorViewTag = 1000
    }
    
    func removeActivityIndicatorView() {
        guard let overlayView: UIView = view.viewWithTag(Constant.spinnerViewTag),
              let activityIndicator = view.viewWithTag(Constant.activityIndicatorViewTag) as? UIActivityIndicatorView else {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0.0
            activityIndicator.stopAnimating()
        }) { _ in
            activityIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }
}
