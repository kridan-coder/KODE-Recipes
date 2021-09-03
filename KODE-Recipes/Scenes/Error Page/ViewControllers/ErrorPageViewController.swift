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
    
    var contentView: ErrorPageView {
        return view as! ErrorPageView
    }
    
    override func loadView() {
        view = ErrorPageView()
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
