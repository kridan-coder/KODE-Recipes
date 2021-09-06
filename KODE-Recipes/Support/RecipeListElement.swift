//
//  RecipeListElement.swift
//  KODE-Recipes
//
//  Created by Developer on 06.09.2021.
//

import Foundation

struct RecipeListElement: Decodable {
    var uuid: String? = nil
    var name: String? = nil
    var images: [String]? = nil
    var lastUpdated: Double? = nil
    var description: String? = nil
    var instructions: String? = nil
    var difficulty: Int? = nil
}

