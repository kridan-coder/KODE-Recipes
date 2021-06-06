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
    
    var didNotFindInternetConnection: (() -> Void)?
    
    var didStartUpdating: (() -> Void)?
    
    var didFinishUpdating: (() -> Void)?
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel]{
        
        var safeRecipes = recipes
            switch sortCase {
            
            case .name:
                safeRecipes.sort{x, y in
                    return x.data.name < y.data.name
                }
            case .date:
                safeRecipes.sort{x, y in
                    return x.data.lastUpdated > y.data.lastUpdated
                }
            }
            
            return safeRecipes
        


    }
    
    func filterRecipesForSearchText(recipes: [RecipeTableViewCellViewModel], searchText: String, scope: SearchCase? = SearchCase.all) -> [RecipeTableViewCellViewModel] {
        
        guard searchText != "" else {return recipesViewModels}
        var safeRecipes = recipes
        switch scope {
        case .name:
            
            safeRecipes = recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.name.lowercased().contains(searchText.lowercased())
            }
            
        case .description:
            safeRecipes = recipesViewModels.filter{(recipe) -> Bool in
                return (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            
        case .instruction:
            safeRecipes = recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.instructions.lowercased().contains(searchText.lowercased())
            }
        default:
            safeRecipes = recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.name.lowercased().contains(searchText.lowercased()) ||
                    (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    recipe.data.instructions.lowercased().contains(searchText.lowercased())
                
                
            }
        }
        return safeRecipes
        
        
        
    }
    
    var coordinatorDelegate: RecipesListViewModelCoordinatorDelegate?
    
    var recipesViewModels: [RecipeTableViewCellViewModel] = []
    
    
    func reloadData(){
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetwork()
        }
        else {
            didNotFindInternetConnection?()
            getDataFromDatabase()
        }
    }
    
    private func setDataToDatabase(recipes: [RecipeDC]){
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
    

}
