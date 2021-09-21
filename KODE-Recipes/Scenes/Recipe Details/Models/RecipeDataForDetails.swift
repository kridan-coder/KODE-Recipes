//
//  RecipeDataForDetails.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit

struct RecipeDataForDetails {
    var recipeID: String
    var name: String
    var imageLinks: [String]
    var lastUpdated: String
    var description: String
    var instructions: String
    var difficultyLevel: Int
    var similarRecipes: [RecipeBrief]
}
