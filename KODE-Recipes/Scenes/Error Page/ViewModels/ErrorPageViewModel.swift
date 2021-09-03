//
//  ErrorPageViewModel.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import Foundation

protocol ErrorPageViewModelCoordinatorDelegate: class {
    func viewWillDisappear()
}

final class ErrorPageViewModel {
    
    // MARK: Private
    
    private let repository: Repository
    
    private var errorType: ErrorType! {
        willSet {
            if newValue == .noInternet {
                errorData = ErrorData(title: Constants.ErrorType.noInternet, description: Constants.ErrorText.noInternet, buttonTitle: Constants.ButtonTitle.refresh)
            }
            else {
                errorData = ErrorData(title: Constants.ErrorType.basic, description: Constants.ErrorText.basic, buttonTitle: Constants.ButtonTitle.refresh)
            }
        }
    }
    
    // MARK: Delegates
    
    weak var coordinatorDelegate: ErrorPageViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    var errorData: ErrorData?
    
    // MARK: Actions
    
    var didReceiveError: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: Service
    
    func reloadData() {
        if repository.isConnectedToNetwork() {
            viewWillDisappear()
        }
        else {
            didReceiveError?()
        }
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: Lifecycle
    
    init(repository: Repository, errorType: ErrorType) {

        self.repository = repository
        changeErrorType(errorType: errorType)
    }
    

    
    // MARK: Helpers
    
    func changeErrorType(errorType: ErrorType) {
        self.errorType = errorType
    }
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }

    
}
