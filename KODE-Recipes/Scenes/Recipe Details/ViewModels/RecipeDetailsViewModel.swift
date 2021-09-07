//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate: class {
    func viewWillDisappear()
}

final class RecipeDetailsViewModel {
    
    // MARK: Private
    
    private let repository: Repository
    
    private let recipeID: String
    
    // MARK: Delegates
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    var imagesViewModels: [ImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            imagesViewModels = recipe!.imageLinks.map { viewModelFor(imageLink: $0) }
        }
    }
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didNotFindInternetConnection: (() -> Void)?
    
    // MARK: Service
    
    func reloadData() {
        self.didStartUpdating?()
        
        if repository.isConnectedToNetwork() {
            getDataFromNetwork()
        }
        else {
            didNotFindInternetConnection?()
        }
        
        //getDataFromDatabase()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: Lifecycle
    
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
    
    // MARK: Helpers
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
//    private func getDataFromDatabase() {
//        if let recipeDC = repository.databaseClient?.getObjectByPrimaryKey(ofType: RecipeDataForDC.self, primaryKey: recipeID) {
//            recipe = repository.recipeDCToRecipeForDetails(recipeDC)
//        }
//        else {
//            self.didReceiveError?(Constants.ErrorText.recipeDetailsAreEmpty)
//        }
//        self.didFinishUpdating?()
//    }
    
    private func getDataFromNetwork() {
        
        repository.apiClient?.getRecipe(uuid: recipeID) { [weak self] response in
            
            switch response {
            case .success(let recipeContainer):
                
                if let safeRecipe = recipeContainer.recipe {
                    self?.recipe = self?.repository.recipeAPIToRecipeForDetails(safeRecipe)
                }
                else {
                    self?.didReceiveError?(Constants.ErrorText.recipeDetailsAreEmpty)
                }
            
                self?.didFinishUpdating?()
                
            case .failure(let error):
                print(error)
                self?.didReceiveError?(Constants.ErrorText.recipeDetailsAreEmpty)
            }
        
            
        }
        
//        repository.apiClient?.getRecipe(uuid: recipeID, onSuccess: { APIrecipe in
//            guard let recipeSafe = APIrecipe else {
//                self.didReceiveError?(Constants.ErrorText.recipesListIsEmpty)
//                return
//            }
//            
//            self.recipe = recipeSafe
//            
//            // received data should be saved locally
////            let recipesDC = recipes.map {
////                return self.repository.recipeACtoRecipeDC($0)
////            }
//            //self.repository.databaseClient?.saveObjects(recipesDC)
//            
//            // set viewModels
////            self.recipesViewModels = recipes.map {
////                let recipe = self.repository.recipeAPIToRecipeForCell($0)
////                return self.viewModelFor(recipe: recipe)
////            }
//            
//            self.didFinishUpdating?()
//            
//        }, onFailure: { error in
//            self.didFinishUpdating?()
//            self.didReceiveError?(error)
//        })
    }
    
}
