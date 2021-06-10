//
//  RecipeDataForCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation

struct RecipeDataForCell {
    var recipeID: String
    var name: String
    var imageLink: String
    var lastUpdated: String
    var description: String?
    
    // instructions are not shown but are used for searching
    var instructions: String
}
