//
//  RecipesListCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

final class RecipesListCoordinator: Coordinator {
    
    // MARK: Properties
    
    let rootNavigationController: UINavigationController
    
    let repository: Repository
    
    weak var delegate: Coordinator?
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
    }
    
    override func start() {
        // init viewModel
        let recipesListViewModel: RecipesListViewModel = {
            let viewModel = RecipesListViewModel(repository: repository)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        // init viewController
        let recipesListViewController: RecipesListViewController = {
            let viewController = RecipesListViewController(viewModel: recipesListViewModel)
            viewController.title = Constants.NavigationBarTitle.recipes
            return viewController
        }()
        
        rootNavigationController.setViewControllers([recipesListViewController], animated: false)
    }
    
}

// MARK: ViewModel Delegate

extension RecipesListCoordinator: RecipesListViewModelCoordinatorDelegate {
    // switches Scene to Recipe Details
    func didSelectRecipe(recipeID: String) {
        let recipeDetailsCoordinator = RecipeDetailsCoordinator(rootNavigationController: rootNavigationController,
                                                                repository: repository,
                                                                recipeID: recipeID)
        
        recipeDetailsCoordinator.delegate = self
        addChildCoordinator(recipeDetailsCoordinator)
        recipeDetailsCoordinator.start()
    }
    
}

// MARK: Coordinator Delegate

extension RecipesListCoordinator: RecipeDetailsDelegate {
    func didFinish(from coordinator: RecipeDetailsCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}
