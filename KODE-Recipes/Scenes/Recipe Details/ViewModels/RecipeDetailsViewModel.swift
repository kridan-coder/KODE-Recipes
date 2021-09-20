//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate: AnyObject {
    func viewWillDisappear()
}

final class RecipeDetailsViewModel {
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var images: [ImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            images = recipe!.imageLinks.map { viewModelFor(imageLink: $0) }
        }
    }
    
    private let repository: Repository
    
    private let recipeID: String
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didFinishSuccessfully: (() -> Void)?
    
    // MARK: - Init
    
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: - Private Methods
    
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
