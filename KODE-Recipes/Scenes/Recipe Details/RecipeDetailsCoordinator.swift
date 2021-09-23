//
//  RecipeDetailsCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import UIKit

protocol RecipeDetailsDelegate: Coordinator {
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
        let recipeViewModel = RecipeDetailsViewModel(repository: repository, recipeID: recipeID)
        recipeViewModel.coordinatorDelegate = self
        
        let recipeViewController = RecipeDetailsViewController(viewModel: recipeViewModel)
        
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
    
    func didSelectRecipe(recipeID: String) {
        let recipeDetailsCoordinator = RecipeDetailsCoordinator(rootNavigationController: rootNavigationController,
                                                                repository: repository,
                                                                recipeID: recipeID)
        
        recipeDetailsCoordinator.delegate = self.delegate
        self.delegate?.addChildCoordinator(recipeDetailsCoordinator)
        rootNavigationController.navigationBar.prefersLargeTitles = false
        recipeDetailsCoordinator.start()
    }
}
