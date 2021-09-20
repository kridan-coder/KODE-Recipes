//
//  RecipeDetailsCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit

protocol RecipeDetailsDelegate: AnyObject {
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
        
        let recipeViewModel: RecipeDetailsViewModel = {
            let viewModel = RecipeDetailsViewModel(repository: repository, recipeID: recipeID)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        let recipeViewController: RecipeDetailsViewController = {
            let viewController = RecipeDetailsViewController(viewModel: recipeViewModel)
            viewController.title = Constants.NavigationBarTitle.recipeDetails
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
        self.finish()
    }
}
