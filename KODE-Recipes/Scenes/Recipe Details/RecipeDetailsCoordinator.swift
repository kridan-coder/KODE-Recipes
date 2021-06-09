//
//  RecipeDetailsCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit

final class RecipeDetailsCoordinator: Coordinator {
    
    // MARK: Properties
    
    let rootNavigationController: UINavigationController
    
    let repository: Repository
    
    let recipeID: String
    
    weak var delegate: Coordinator?
    
    // MARK: Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository, recipeID: String) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
        self.recipeID = recipeID
    }
    
    override func start() {
        
        // init viewModel
        let recipeViewModel: RecipeDetailsViewModel! = {
            let viewModel = RecipeDetailsViewModel(repository: repository, recipeID: recipeID)
            viewModel.coordinatorDelegate = self
            return viewModel
        }()
        
        // init viewController
        let recipeViewController: RecipeDetailsViewController! = {
            let viewController = RecipeDetailsViewController(nibName: "RecipeDetailsViewController", bundle: nil)
            viewController.viewModel = recipeViewModel
            viewController.title = Constants.NavigationBarTitle.recipeDetails
            return viewController
        }()
        
        rootNavigationController.pushViewController(recipeViewController, animated: true)
    }
    
}

extension RecipeDetailsCoordinator: RecipeViewModelCoordinatorDelegate {}
