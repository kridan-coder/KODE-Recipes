//
//  ErrorPageCoordinator.swift
//  KODE-Recipes
//
//  Created by Developer on 03.09.2021.
//

import Foundation
import UIKit

final class ErrorPageCoordinator: Coordinator {
    
    // MARK: Properties
    
    let rootNavigationController: UINavigationController
    
    let repository: Repository
    
    let errorType: ErrorType
    
    weak var delegate: Coordinator?
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository, errorType: ErrorType) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
        self.errorType = errorType
    }
    
    override func start() {
        
        // init viewModel
        let errorPageViewModel: ErrorPageViewModel! = {
            let viewModel = ErrorPageViewModel(repository: repository, errorType: errorType)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        rootNavigationController.navigationBar.isHidden = true
        
        // init viewController
        let errorPageViewController: ErrorPageViewController! = {
            let viewController = ErrorPageViewController()
            viewController.viewModel = errorPageViewModel
            return viewController
        }()
        
        rootNavigationController.pushViewController(errorPageViewController, animated: true)
    }
    
}

// MARK: ViewModel Delegate

extension ErrorPageCoordinator: ErrorPageViewModelCoordinatorDelegate {
    
    func viewWillDisappear() {
        rootNavigationController.popViewController(animated: true)
    }
    
}

// MARK: Coordinator Delegate

extension ErrorPageCoordinator: RecipeDetailsDelegate {
    
    func didFinish(from coordinator: RecipeDetailsCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}
