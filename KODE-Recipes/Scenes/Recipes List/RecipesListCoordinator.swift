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
    
    
    // MARK: VM/VC's
    
    lazy var recipesListViewModel: RecipesListViewModel! = {
        let viewModel = RecipesListViewModel()
        viewModel.coordinatorDelegate = self
        viewModel.repository = self.repository
        return viewModel
    }()
    
    
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, apiClient: ApiClient, databaseClient: DatabaseClient, repository: Repository){
        self.rootNavigationController = rootNavigationController
        self.apiClient = apiClient
        self.databaseClient = databaseClient
        self.repository = repository
    }
    
    override func start() {
        let recipesListViewController = RecipesListViewController(nibName: "RecipesListViewController", bundle: nil)
        recipesListViewController.viewModel = recipesListViewModel
        recipesListViewController.title = "Recipes"
        
        rootNavigationController.setViewControllers([recipesListViewController], animated: false)
    }
}
extension RecipesListCoordinator: RecipesListViewModelCoordinatorDelegate{
    func didSelectRecipe(recipe: Recipe) {
        let viewModel = RecipeViewModel()
        viewModel.coordinatorDelegate = self
        viewModel.recipe = recipe
        let recipeViewController = RecipeViewController(nibName: "RecipeViewController", bundle: nil)
        recipeViewController.viewModel = viewModel
        recipeViewController.title = "Recipe Details"
        rootNavigationController.pushViewController(recipeViewController, animated: true)
    }
    
    
}

extension RecipesListCoordinator: RecipeViewModelCoordinatorDelegate {
    
}
