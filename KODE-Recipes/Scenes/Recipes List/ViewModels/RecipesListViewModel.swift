//
//  RecipesTableViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
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
            getDataFromNetwork()
        }
        else {
            didNotFindInternetConnection?()
            //getDataFromDatabase()
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
    
//    private func getDataFromDatabase() {
//        if let recipes = repository.databaseClient?.getObjects(ofType: RecipeDataForDC.self) {
//            recipesViewModels = recipes.map {
//                let recipe = repository.recipeDCToRecipeForCell($0)
//                return viewModelFor(recipe: recipe)
//            }
//        }
//        self.didFinishUpdating?()
//    }
    
    private func getDataFromNetwork() {
        
        repository.apiClient?.getAllRecipes { recipesContainer in
            
            switch recipesContainer {
            case .success(let data):
                // set viewModels
                self.recipesViewModels = data.recipes?.map {
                    let recipe = self.repository.recipeAPIToRecipeForCell($0)
                    return self.viewModelFor(recipe)
                } ?? []
    
                self.didFinishUpdating?()
                
            case .failure(let error):
                print(error)
                self.didReceiveError?(Constants.ErrorText.recipesListIsEmpty)
            }
            
        }
        
//        repository.apiClient?.getAllRecipes(onSuccess: { APIrecipes in
//            guard let recipes = APIrecipes else {
//                self.didReceiveError?(Constants.ErrorText.recipesListIsEmpty)
//                return
//            }
//
//            // received data should be saved locally
////            let recipesDC = recipes.map {
////                return self.repository.recipeACtoRecipeDC($0)
////            }
//            //self.repository.databaseClient?.saveObjects(recipesDC)
//
//            // set viewModels
//            self.recipesViewModels = recipes.map {
//                let recipe = self.repository.recipeAPIToRecipeForCell($0)
//                return self.viewModelFor(recipe)
//            }
//
//            self.didFinishUpdating?()
//
//        }, onFailure: { error in
//            self.didFinishUpdating?()
//            self.didReceiveError?(error)
//        })
    }
    
}
