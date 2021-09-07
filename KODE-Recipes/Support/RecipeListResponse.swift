//
//  RecipeListResponse.swift
//  KODE-Recipes
//
//  Created by Developer on 07.09.2021.
//

import Foundation

struct RecipeListResponse: Decodable {
    var recipes: [RecipeListElement]? = nil
}
