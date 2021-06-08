//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate: class {}

final class RecipeDetailsViewModel {
    
    // MARK: Delegates
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    var imagesViewModels: [ImageCollectionViewCellViewModel] = []
    
    var recipe: Recipe {
        didSet {
            imagesViewModels = recipe.imageLinks.map { viewModelFor(imageLink: $0) }
        }
    }
    
    // MARK: Lifecycle
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    // MARK: Helpers
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
}
