//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate {}

final class RecipeDetailsViewModel {
    
    // MARK: Public
    
    var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var imagesViewModels: [ImageCollectionViewCellViewModel] = []
    
    var recipe: Recipe! {
        didSet {
            imagesViewModels = recipe.imageLinks.map { viewModelFor(imageLink: $0) }
        }
    }
    
    // MARK: Private
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
}
