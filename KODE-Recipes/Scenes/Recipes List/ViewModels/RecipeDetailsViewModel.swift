//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate{
    
}

final class RecipeDetailsViewModel {
    var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var imagesViewModels: [ImageCollectionViewCellViewModel] = []
    
    var recipe: Recipe! {
        didSet {
            imagesViewModels = recipe.imageLinks.map {return viewModelFor(imageLink: $0)}
        }
    }
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
}
