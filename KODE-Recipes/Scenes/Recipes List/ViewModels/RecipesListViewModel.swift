//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit

protocol RecipesListViewModelCoordinatorDelegate: AnyObject {
    func didSelectRecipe(recipeID: String)
}

final class RecipesListViewModel {
    
    // MARK: - Properties
    
    var recipesViewModels: [RecipeTableViewCellViewModel] = []
    
    weak var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    private let repository: Repository
    
    // MARK: Init
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: - Public Methods
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func filterRecipesForSearchText(searchText: String?, scope: SearchCase?) -> [RecipeTableViewCellViewModel] {
        repository.filterRecipesForSearchText(recipes: recipesViewModels, searchText: searchText, scope: scope)
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel] {
        repository.sortRecipesBy(sortCase: sortCase, recipes: recipes)
    }
    
    // MARK: Private Methods
    
    private func viewModelFor(_ recipe: RecipeDataForCell) -> RecipeTableViewCellViewModel {
        let viewModel = RecipeTableViewCellViewModel(recipe: recipe)
        
        viewModel.didSelectRecipe = { [weak self] recipeID in
            self?.coordinatorDelegate?.didSelectRecipe(recipeID: recipeID)
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError?(error)
        }
        
        return viewModel
    }
    
    private func getDataFromNetwork() {
        repository.apiClient?.getAllRecipes { response in
            
            switch response {
            case .success(let recipesContainer):
                
                self.recipesViewModels = recipesContainer.recipes.compactMap {
                    let recipe = self.repository.recipeAPIToRecipeForCell($0)
                    return self.viewModelFor(recipe)
                }
                
                self.didFinishUpdating?()
                
            case .failure(let error):
                self.didReceiveError?(error)
            }
        }
    }
    
}
