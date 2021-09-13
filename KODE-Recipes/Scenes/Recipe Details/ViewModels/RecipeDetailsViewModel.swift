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
    
    // MARK: Service
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
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
    
    private func getDataFromNetwork() {
        
        repository.apiClient?.getRecipe(uuid: recipeID) { [weak self] response in
            
            switch response {
            
            case .success(let recipeContainer):
                self?.recipe = self?.repository.recipeAPIToRecipeForDetails(recipeContainer.recipe)
                self?.didFinishUpdating?()
                
            case .failure(let error):
                // TODO: - pass error to didReceiveError method
                self?.didReceiveError?(Constants.ErrorText.recipeDetailsAreEmpty)
            }
            
        }
    }
    
}
