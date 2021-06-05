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

final class RecipeViewModel {
    var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var recipe: Recipe!
    
}
