//
//  RecipesListCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

class RecipesListCoordinator: Coordinator {
    
    // MARK: Properties
    
    let rootNavigationController: UINavigationController
    
    let apiClient: ApiClient
    let databaseClient: DatabaseClient
    let repository: Repository
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, apiClient: ApiClient, databaseClient: DatabaseClient, repository: Repository) {
        self.rootNavigationController = rootNavigationController
        self.apiClient = apiClient
        self.databaseClient = databaseClient
        self.repository = repository
    }
    
    override func start() {
        
        // init viewModel
        let recipesListViewModel: RecipesListViewModel! = {
            let viewModel = RecipesListViewModel(repository: self.repository)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        // init viewController
        let recipesListViewController: RecipesListViewController! = {
            let viewController = RecipesListViewController(nibName: "RecipesListViewController", bundle: nil)
            viewController.viewModel = recipesListViewModel
            viewController.title = "Recipes"
            return viewController
        }()
        
        rootNavigationController.setViewControllers([recipesListViewController], animated: false)
    }
    
}

extension RecipesListCoordinator: RecipesListViewModelCoordinatorDelegate {
    
    // moves user to Recipe Details viewController (Scene remains the same)
    func didSelectRecipe(recipe: Recipe) {
        
        // init viewModel
        let recipeViewModel: RecipeDetailsViewModel! = {
            let viewModel = RecipeDetailsViewModel()
            viewModel.coordinatorDelegate = self
            viewModel.recipe = recipe
            return viewModel
        }()
        
        // init viewController
        let recipeViewController: RecipeDetailsViewController! = {
            let viewController = RecipeDetailsViewController(nibName: "RecipeDetailsViewController", bundle: nil)
            viewController.viewModel = recipeViewModel
            viewController.title = "Recipe Details"
            return viewController
        }()
        
        rootNavigationController.pushViewController(recipeViewController, animated: true)
    }
    
}

extension RecipesListCoordinator: RecipeViewModelCoordinatorDelegate {}
