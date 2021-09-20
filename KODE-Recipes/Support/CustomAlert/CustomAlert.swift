//
//  ErrorAlert.swift
//  KODE-Recipes
//
//  Created by Developer on 06.09.2021.
//

import Foundation
import UIKit

protocol CustomAlertDisplaying {
    
    var targetView: UIView { get }
    
    func setupCustomAlert(_ alertView: ErrorPageView)
    func removeCustomAlert(_ alertView: ErrorPageView)
    
    func showCustomAlert(_ alertView: ErrorPageView, title: String, message: String, buttonText: String)
    func hideCustomAlert(_ alertView: ErrorPageView)
    
    func handleButtonTap()
}

extension CustomAlertDisplaying where Self: UIViewController {
    
    var targetView: UIView { return self.view }
    
    func setupCustomAlert(_ alertView: ErrorPageView) {
        targetView.addSubview(alertView)
        
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.didPressButton = {
            self.handleButtonTap()
        }
    }
    
    func removeCustomAlert(_ alertView: ErrorPageView) {
        alertView.removeFromSuperview()
    }
    
    func showCustomAlert(_ alertView: ErrorPageView, title: String, message: String, buttonText: String) {
        alertView.setData(with: title, message: message, buttonText: buttonText)
        alertView.isHidden = false    }
    
    func hideCustomAlert(_ alertView: ErrorPageView) {
        alertView.isHidden = true
    }
    
}
