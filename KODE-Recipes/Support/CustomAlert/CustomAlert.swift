//
//  ErrorAlert.swift
//  KODE-Recipes
//
//  Created by Developer on 06.09.2021.
//

import Foundation
import UIKit

// i think it should be singleton or i need DI like for APIClient or DatabaseClient
class CustomAlert {
    
    private let contentView = CustomAlertView()
    
    var isShown = false
    
    func showAlert(with title: String, message: String, buttonText: String, on viewController: UIViewController, completion completed: @escaping () -> Void) {
        guard let targetView = viewController.view else {
            return
        }

        targetView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.setData(with: title, message: message, buttonText: buttonText)
        contentView.didPressButton = {
            completed()
        }
        
        isShown = true
    }
    
    func dismissAlert() {
        contentView.removeFromSuperview()
        isShown = false
    }
    
}
