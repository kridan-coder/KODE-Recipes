//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit

protocol RecipesListViewModelCoordinatorDelegate: class {
    func didSelectRecipe(recipeID: String)
}

final class RecipesListViewModel {
    
    // MARK: Private
    
    private let repository: Repository
    
    // MARK: Delegates
    
    weak var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    var recipesViewModels: [RecipeTableViewCellViewModel] = []
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didNotFindInternetConnection: (() -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: Service
    
    func reloadData() {
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetworkAndSaveItLocally()
        } else {
            didNotFindInternetConnection?()
        }
    }
    
    func filterRecipesForSearchText(searchText: String?, scope: SearchCase?) -> [RecipeTableViewCellViewModel] {
        repository.filterRecipesForSearchText(recipes: recipesViewModels, searchText: searchText, scope: scope)
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel] {
        repository.sortRecipesBy(sortCase: sortCase, recipes: recipes)
    }
    
    // MARK: Lifecycle
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: Helpers
    
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
    
    private func getDataFromNetworkAndSaveItLocally() {
        repository.apiClient?.getRecipes(onSuccess: { recipesContainer in
            guard let recipes = recipesContainer.recipes else {
                self.didReceiveError?(Constants.ErrorText.recipesListIsEmpty)
                return
            }
            
            // set viewModels
            self.recipesViewModels = recipes.map {
                let recipe = self.repository.recipeACToRecipeForCell($0)
                return self.viewModelFor(recipe: recipe)
            }
            
            self.didFinishUpdating?()
            
        }, onFailure: { error in
            self.didFinishUpdating?()
            self.didReceiveError?(error)
        })
    }
    
}
