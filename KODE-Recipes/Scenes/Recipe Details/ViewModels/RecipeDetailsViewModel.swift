//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit

protocol RecipeViewModelCoordinatorDelegate: AnyObject {
    func viewWillDisappear()
    func didSelectRecipe(recipeID: String)
}

final class RecipeDetailsViewModel {
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var images: [ImageCollectionViewCellViewModel] = []
    
    var recipeImages: [ImageCollectionViewCellViewModel] = []
    
    var recipeRecommendationImages: [RecommendedImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            recipeImages = recipe?.imageLinks.map { viewModelForMain(imageLink: $0) } ?? []
            recipeRecommendationImages = recipe?.similarRecipes.map { viewModelForRecommended(name: $0.name, imageLink: $0.image, uuid: $0.uuid) } ?? []
        }
    }
    
    private let repository: Repository
    
    private let recipeID: String
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
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
    
    
    private func viewModelForMain(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
    private func viewModelForRecommended(name: String, imageLink: String, uuid: String) -> RecommendedImageCollectionViewCellViewModel {
        let viewModel = RecommendedImageCollectionViewCellViewModel(name: name, imageLink: imageLink, uuid: uuid)
        viewModel.didSelectRecommendedRecipe = { [weak self] recipeID in
            self?.coordinatorDelegate?.didSelectRecipe(recipeID: recipeID)
        }
        return viewModel
    }
    
    private func getDataFromNetwork() {
        repository.apiClient?.getRecipe(uuid: recipeID) { [weak self] response in
            
            switch response {
            case .success(let recipeContainer):
                self?.recipe = self?.repository.recipeToRecipeForDetails(recipeContainer.recipe)
                self?.didFinishUpdating?()
                
            case .failure(let error):
                self?.didReceiveError?(error)
            }
        }
    }
    
}
