//
//  ErrorAlert.swift
//  KODE-Recipes
//
//  Created by Developer on 06.09.2021.
//

import Foundation
import UIKit

class CustomAlert {
    
    private let contentView = CustomAlertView()
    
    func showAlert(with title: String, message: String, buttonText: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        
        viewController.navigationController?.navigationBar.isHidden = true
        
        //contentView.frame = targetView.bounds
        


        targetView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        //contentView.frame = targetView.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.initializeUI()
        contentView.createConstraints()
        contentView.setData(with: title, message: message, buttonText: buttonText)
        

        
//        UIView.animate(withDuration: 0.25, animations:  {
//            self.contentView.center = targetView.center
//        }, completion: { done in
//            if done {
//
//
//            }
//        })
        
    }
    
    func dismissAlert() {
        
        
    }
    
}
