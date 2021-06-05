//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipesListViewModelCoordinatorDelegate{
    func didSelectRecipe(recipe: Recipe)
}

final class RecipesListViewModel {
    
    var repository: Repository!
    

    
    var didReceiveError: ((String) -> Void)?
    
    var didStartUpdating: (() -> Void)?
    
    var didFinishUpdating: (() -> Void)?
    
    
    
    var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    var recipesViewModels: [RecipeCellViewModel] = []
    
    
    func reloadData(){
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetwork()
        }
        else {
            
        }
    }
    
    private func getDataFromDatabase() -> RecipesContainerR? {
        return repository.databaseClient?.getRecipesContainerFromDatabase()
    }
    
    private func getDataFromNetwork(){
        repository.apiClient?.getRecipes(onSuccess: {recipesContainer in

            
            guard let recipes = recipesContainer.recipes else {
                self.didReceiveError?("Recipes list is empty.")
                return
            }
            
            self.recipesViewModels = recipes.map{
                let recipe = self.recipeACtoRecipe(recipeAC: $0)
                return self.viewModelFor(recipe: recipe)}
            
            self.didFinishUpdating?()
            
        }, onFailure: {error in
            self.didFinishUpdating?()
            self.didReceiveError?(error)
        })
    }
    
    private func viewModelFor(recipe: Recipe) -> RecipeCellViewModel{
        let viewModel = RecipeCellViewModel(recipe: recipe)
        viewModel.didSelectRecipe = { [weak self] recipe in
            self?.coordinatorDelegate?.didSelectRecipe(recipe: recipe)
            
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError?(error)
        }
        return viewModel
    }
    
    private func recipeACtoRecipe(recipeAC: RecipeAC) -> Recipe {
        return Recipe(name: recipeAC.name!, imageLinks: recipeAC.images!, lastUpdated: recipeAC.lastUpdated!, description: recipeAC.description, instructions: recipeAC.instructions!, difficulty: recipeAC.difficulty!)
    }
}
