//
//  RecipeDataForCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation

struct RecipeDataForCell {
    let recipeID: String
    let name: String
    let imageLink: String
    let lastUpdated: String
    let description: String?
    
    // instructions are not shown but are used for searching
    let instructions: String
    // date (number) is not shown but is used for sorting
    let date: Double
}
