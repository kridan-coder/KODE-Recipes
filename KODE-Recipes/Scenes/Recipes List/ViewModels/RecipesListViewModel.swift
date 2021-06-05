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
            getDataFromDatabase()
        }
    }
    
    private func setDataToDatabase(recipes: [RecipeR]){
        if let container = repository?.wrapIntoDatabaseContainer(recipes: recipes) {
            repository?.databaseClient?.setRecipesContainerToDatabase(container)
        }

    }
    
    private func getDataFromDatabase(){
        
        
        
        if let recipeContainer = repository.databaseClient?.getRecipesContainerFromDatabase() {
            self.recipesViewModels = recipeContainer.recipes.map{
                let recipe = self.repository.recipeRtoRecipe(recipeR: $0)
                return self.viewModelFor(recipe: recipe)}
            
        }
        

        
        self.didFinishUpdating?()
    }
    
    private func getDataFromNetwork(){
        repository.apiClient?.getRecipes(onSuccess: {recipesContainer in

            
            guard let recipes = recipesContainer.recipes else {
                self.didReceiveError?("Recipes list is empty.")
                return
            }
            

            
            let recipesR = recipes.map {
                return self.repository.recipeACtoRecipeR(recipeAC: $0)
            }
            self.setDataToDatabase(recipes: recipesR)
            
            self.recipesViewModels = recipes.map{
                let recipe = self.repository.recipeACtoRecipe(recipeAC: $0)
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
    

}
