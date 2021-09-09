//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipesListViewModelCoordinatorDelegate: AnyObject {
    func didSelectRecipe(recipeID: String)
}

final class RecipesListViewModel {
    
    
    //MARK: - Properties
    
    var recipesViewModels: [RecipeTableViewCellViewModel] = []
    
    weak var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    private let repository: Repository
    
    // MARK: Init
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: Public Methods
    
    // Service
    
    func reloadData() {
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetworkAndSaveItLocally()
        }
        else {
            didNotFindInternetConnection?()
            getDataFromDatabase()
        }
    }
    
    func filterRecipesForSearchText(searchText: String?, scope: SearchCase?) -> [RecipeTableViewCellViewModel] {
        repository.filterRecipesForSearchText(recipes: recipesViewModels, searchText: searchText, scope: scope)
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel] {
        repository.sortRecipesBy(sortCase: sortCase, recipes: recipes)
    }
    
    // MARK: Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didNotFindInternetConnection: (() -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didFinishSuccessfully: (() -> Void)?
    
    // MARK: Private Methods
    
    private func viewModelFor(recipe: RecipeDataForCell) -> RecipeTableViewCellViewModel {
        let viewModel = RecipeTableViewCellViewModel(recipe: recipe)
        
        viewModel.didSelectRecipe = { [weak self] recipeID in
            self?.coordinatorDelegate?.didSelectRecipe(recipeID: recipeID)
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError?(error)
        }
        
        return viewModel
    }
    
    private func getDataFromDatabase() {
        if let recipes = repository.databaseClient?.getObjects(ofType: RecipeDataForDC.self) {
            recipesViewModels = recipes.map {
                let recipe = repository.recipeDCToRecipeForCell($0)
                return viewModelFor(recipe: recipe)
            }
        }
        self.didFinishUpdating?()
    }
    
    private func getDataFromNetworkAndSaveItLocally() {
        repository.apiClient?.getRecipes(onSuccess: { recipesContainer in
            guard let recipes = recipesContainer.recipes else {
                self.didReceiveError?(ErrorType.basic)
                return
            }
            
            // received data should be saved locally
            let recipesDC = recipes.map {
                return self.repository.recipeACtoRecipeDC($0)
            }
            self.repository.databaseClient?.saveObjects(recipesDC)
            
            // set viewModels
            self.recipesViewModels = recipes.map {
                let recipe = self.repository.recipeACToRecipeForCell($0)
                return self.viewModelFor(recipe: recipe)
            }
            
            self.didFinishUpdating?()
            self.didFinishSuccessfully?()
            
        }, onFailure: { error in
            self.didFinishUpdating?()
            self.didReceiveError?(ErrorType.basic)
        })
    }
    
}
