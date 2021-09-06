//
//  ErrorPageViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import UIKit
import SnapKit

class ErrorPageViewController: UIViewController {

    
    // MARK: Public
    
    var viewModel: ErrorPageViewModel!
    
    var contentView: CustomAlertView {
        return view as! CustomAlertView
    }
    
    override func loadView() {
        //view = CustomAlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData(viewModel.errorData)
        
    }
    
    func setupData(_ errorData: ErrorData?) {
        contentView.titleTextLabel.text = errorData?.title
        contentView.descriptionTextLabel.text = errorData?.description
        contentView.refreshButton.setTitle(errorData?.buttonTitle, for: .normal)
    }
    

    

}
