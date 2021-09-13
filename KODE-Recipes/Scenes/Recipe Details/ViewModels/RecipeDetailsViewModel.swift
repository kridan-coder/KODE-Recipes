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
        getDataFromDatabase()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: - Private Methods
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
    private func getDataFromDatabase() {
        if let recipeDC = repository.databaseClient?.getObjectByPrimaryKey(ofType: RecipeDataForDC.self, primaryKey: recipeID) {
            recipe = repository.recipeDCToRecipeForDetails(recipeDC)
            self.didFinishSuccessfully?()
        }
        else {
            self.didReceiveError?(ErrorType.basic)
        }
        self.didFinishUpdating?()
    }
    
}
