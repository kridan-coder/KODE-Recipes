//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipesListViewModelCoordinatorDelegate {
    func didSelectRecipe(recipe: Recipe)
}

final class RecipesListViewModel {
    
    // MARK: Private
    
    private let repository: Repository
    
    // MARK: Public
    
    var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    var recipesViewModels: [RecipeTableViewCellViewModel] = []
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didNotFindInternetConnection: (() -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    func reloadData() {
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetwork()
        }
        else {
            didNotFindInternetConnection?()
            getDataFromDatabase()
        }
    }
    
    func filterRecipesForSearchText(searchText: String, scope: SearchCase?) -> [RecipeTableViewCellViewModel] {
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
    
    private func viewModelFor(recipe: Recipe) -> RecipeTableViewCellViewModel{
        let viewModel = RecipeTableViewCellViewModel(recipe: recipe)
        
        viewModel.didSelectRecipe = { [weak self] recipe in
            self?.coordinatorDelegate?.didSelectRecipe(recipe: recipe)
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError?(error)
        }
        
        return viewModel
    }
    
    private func getDataFromDatabase() {
        if let recipeContainer = repository.databaseClient?.getRecipesContainerFromDatabase() {
            recipesViewModels = recipeContainer.recipes.map {
                let recipe = repository.recipeDCtoRecipe($0)
                return viewModelFor(recipe: recipe)
            }
        }
        
        self.didFinishUpdating?()
    }
    
    private func getDataFromNetwork() {
        repository.apiClient?.getRecipes(onSuccess: { recipesContainer in
            guard let recipes = recipesContainer.recipes else {
                self.didReceiveError?("Recipes list is empty.")
                return
            }
            
            // received data should be saved locally
            let recipesR = recipes.map {
                return self.repository.recipeACtoRecipeDC($0)
            }
            self.setDataToDatabase(recipesDC: recipesR)
            
            // set viewModels
            self.recipesViewModels = recipes.map {
                let recipe = self.repository.recipeACtoRecipe($0)
                return self.viewModelFor(recipe: recipe)
            }
            
            self.didFinishUpdating?()
            
        }, onFailure: { error in
            self.didFinishUpdating?()
            self.didReceiveError?(error)
        })
    }
    
    private func setDataToDatabase(recipesDC: [RecipeDC]) {
        let container = repository.wrapRecipesDCIntoDatabaseContainer(recipesDC)
        repository.databaseClient?.setRecipesContainerToDatabase(container)
    }
    
}