//
//  RecipeDetailsCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import UIKit

protocol RecipeDetailsDelegate: class {
    func didFinish(from coordinator: RecipeDetailsCoordinator)
}

final class RecipeDetailsCoordinator: Coordinator {
    
    // MARK: Properties
    
    let rootNavigationController: UINavigationController
    
    let repository: Repository
    
    let recipeID: String
    
    weak var delegate: RecipeDetailsDelegate?
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository, recipeID: String) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
        self.recipeID = recipeID
    }
    
    override func start() {
        // init viewModel
        let recipeViewModel: RecipeDetailsViewModel = {
            let viewModel = RecipeDetailsViewModel(repository: repository, recipeID: recipeID)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        // init viewController
        let recipeViewController: RecipeDetailsViewController = {
            let viewController = RecipeDetailsViewController()
            viewController.viewModel = recipeViewModel
            return viewController
        }()
        
        rootNavigationController.pushViewController(recipeViewController, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
    
}

// MARK: ViewModel Delegate

extension RecipeDetailsCoordinator: RecipeViewModelCoordinatorDelegate {
    func viewWillDisappear() {
        rootNavigationController.navigationBar.prefersLargeTitles = true
        self.finish()
    }
    
}
