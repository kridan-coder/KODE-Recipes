//
//  RecipesListCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

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
        let recipesListViewModel = RecipesListViewModel(repository: repository)
        recipesListViewModel.coordinatorDelegate = self
        
        let recipesListViewController = RecipesListViewController(viewModel: recipesListViewModel)
        recipesListViewController.title = Constants.NavigationBarTitle.recipes
        
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
        rootNavigationController.navigationBar.prefersLargeTitles = false
        recipeDetailsCoordinator.start()
    }
    
}

// MARK: Coordinator Delegate

extension RecipesListCoordinator: RecipeDetailsDelegate {
    func didFinish(from coordinator: RecipeDetailsCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}
